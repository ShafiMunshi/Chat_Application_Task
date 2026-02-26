import 'dart:developer';
import 'package:chat_application_task/core/services/speech_to_text_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'speech_to_text_provider.g.dart';

// Provider for the speech-to-text service
@Riverpod(keepAlive: true)
SpeechToTextService speechToTextService(SpeechToTextServiceRef ref) {
  return SpeechToTextService();
}

// State class for speech recognition
class SpeechRecognitionState {
  final bool isListening;
  final bool isInitialized;
  final String partialText;
  final String finalText;
  final String error;
  final double confidence;
  final SpeechState speechState;

  const SpeechRecognitionState({
    this.isListening = false,
    this.isInitialized = false,
    this.partialText = '',
    this.finalText = '',
    this.error = '',
    this.confidence = 0.0,
    this.speechState = SpeechState.ready,
  });

  SpeechRecognitionState copyWith({
    bool? isListening,
    bool? isInitialized,
    String? partialText,
    String? finalText,
    String? error,
    double? confidence,
    SpeechState? speechState,
  }) {
    return SpeechRecognitionState(
      isListening: isListening ?? this.isListening,
      isInitialized: isInitialized ?? this.isInitialized,
      partialText: partialText ?? this.partialText,
      finalText: finalText ?? this.finalText,
      error: error ?? this.error,
      confidence: confidence ?? this.confidence,
      speechState: speechState ?? this.speechState,
    );
  }
}

// Provider for managing speech recognition state
@riverpod
class SpeechRecognition extends _$SpeechRecognition {
  ISpeechToTextService get _service => ref.read(speechToTextServiceProvider);

  @override
  SpeechRecognitionState build() {
    return const SpeechRecognitionState();
  }

  Future<void> initialize() async {
    try {
      final isInitialized = await _service.initialize();
      state = state.copyWith(
        isInitialized: isInitialized,
        error: isInitialized ? '' : _service.lastError,
      );
    } catch (e) {
      log('Failed to initialize speech recognition: $e');
      state = state.copyWith(
        error: 'Failed to initialize: $e',
        isInitialized: false,
      );
    }
  }

  Future<void> startListening(Function(String)? onFinalResult) async {
    if (!state.isInitialized) {
      await initialize();
    }

    if (!state.isInitialized) {
      log('Cannot start listening: Speech recognition not initialized');
      return;
    }

    try {
      // Clear previous texts
      state = state.copyWith(
        partialText: '',
        finalText: '',
        error: '',
      );

      final success = await _service.startListening(
        onResult: (text) {
          log('Final speech result: $text');
          state = state.copyWith(
            finalText: text,
            partialText: '',
            isListening: false,
            speechState: _service.speechState,
            confidence: _service.confidenceLevel,
          );
          
          // Call the callback with the final result
          onFinalResult?.call(text);
        },
        onPartialResult: (text) {
          log('Partial speech result: $text');
          state = state.copyWith(
            partialText: text,
            speechState: _service.speechState,
          );
        },
      );

      if (success) {
        state = state.copyWith(
          isListening: true,
          speechState: _service.speechState,
        );
        log('Speech recognition started successfully');
      } else {
        state = state.copyWith(
          error: _service.lastError,
          speechState: _service.speechState,
        );
        log('Failed to start speech recognition: ${_service.lastError}');
      }
    } catch (e) {
      log('Error starting speech recognition: $e');
      state = state.copyWith(
        error: 'Error starting listening: $e',
        isListening: false,
        speechState: SpeechState.error,
      );
    }
  }

  Future<void> stopListening() async {
    try {
      await _service.stopListening();
      state = state.copyWith(
        isListening: false,
        speechState: _service.speechState,
      );
      log('Speech recognition stopped');
    } catch (e) {
      log('Error stopping speech recognition: $e');
      state = state.copyWith(
        error: 'Error stopping listening: $e',
        isListening: false,
        speechState: SpeechState.error,
      );
    }
  }

  Future<void> cancelListening() async {
    try {
      await _service.cancelListening();
      state = state.copyWith(
        isListening: false,
        partialText: '',
        speechState: _service.speechState,
      );
      log('Speech recognition cancelled');
    } catch (e) {
      log('Error cancelling speech recognition: $e');
      state = state.copyWith(
        error: 'Error cancelling listening: $e',
        isListening: false,
        speechState: SpeechState.error,
      );
    }
  }

  void clearText() {
    state = state.copyWith(
      partialText: '',
      finalText: '',
      error: '',
    );
  }
}
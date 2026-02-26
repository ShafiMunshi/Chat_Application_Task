import 'dart:developer';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum SpeechState {
  ready,
  listening,
  processing,
  error,
}

abstract class ISpeechToTextService {
  Future<bool> initialize();
  Future<bool> startListening({
    required Function(String) onResult,
    required Function(String) onPartialResult,
  });
  Future<void> stopListening();
  Future<void> cancelListening();
  bool get isInitialized;
  bool get isListening;
  SpeechState get speechState;
  String get lastError;
  double get confidenceLevel;
}

class SpeechToTextService implements ISpeechToTextService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  
  SpeechState _speechState = SpeechState.ready;
  String _lastError = '';
  double _confidenceLevel = 0.0;
  
  @override
  bool get isInitialized => _speechToText.isAvailable;
  
  @override
  bool get isListening => _speechToText.isListening;
  
  @override
  SpeechState get speechState => _speechState;
  
  @override
  String get lastError => _lastError;
  
  @override
  double get confidenceLevel => _confidenceLevel;

  @override
  Future<bool> initialize() async {
    try {
      bool available = await _speechToText.initialize(
        onError: (errorNotification) {
          log('Speech recognition error: ${errorNotification.errorMsg}');
          _lastError = errorNotification.errorMsg;
          _speechState = SpeechState.error;
        },
        onStatus: (status) {
          log('Speech recognition status: $status');
          if (status == 'listening') {
            _speechState = SpeechState.listening;
          } else if (status == 'notListening') {
            _speechState = SpeechState.ready;
          }
        },
      );
      
      if (available) {
        _speechState = SpeechState.ready;
        log('Speech recognition initialized successfully');
      } else {
        _speechState = SpeechState.error;
        _lastError = 'Speech recognition not available on this device';
        log('Speech recognition not available');
      }
      
      return available;
    } catch (e) {
      log('Failed to initialize speech recognition: $e');
      _speechState = SpeechState.error;
      _lastError = 'Failed to initialize: $e';
      return false;
    }
  }

  @override
  Future<bool> startListening({
    required Function(String) onResult,
    required Function(String) onPartialResult,
  }) async {
    if (!isInitialized) {
      bool initialized = await initialize();
      if (!initialized) return false;
    }

    try {
      _speechState = SpeechState.listening;
      _lastError = '';
      
      await _speechToText.listen(
        onResult: (result) {
          _confidenceLevel = result.confidence;
          
          if (result.finalResult) {
            log('Final result: ${result.recognizedWords} (confidence: ${result.confidence})');
            onResult(result.recognizedWords);
            _speechState = SpeechState.ready;
          } else {
            log('Partial result: ${result.recognizedWords}');
            onPartialResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30), // Maximum listening duration
        pauseFor: const Duration(seconds: 3),   // Pause threshold
        partialResults: true,                   // Enable partial results
        onSoundLevelChange: (level) {
          // Optional: Handle sound level changes for visual feedback
          log('Sound level: $level');
        },
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
        localeId: 'en_US', // You can make this configurable
      );
      
      return true;
    } catch (e) {
      log('Failed to start listening: $e');
      _speechState = SpeechState.error;
      _lastError = 'Failed to start listening: $e';
      return false;
    }
  }

  @override
  Future<void> stopListening() async {
    if (isListening) {
      await _speechToText.stop();
      _speechState = SpeechState.ready;
      log('Speech recognition stopped');
    }
  }

  @override
  Future<void> cancelListening() async {
    if (isListening) {
      await _speechToText.cancel();
      _speechState = SpeechState.ready;
      log('Speech recognition cancelled');
    }
  }
}
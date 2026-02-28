import 'dart:developer';

import 'package:chat_application_task/core/logger/log.dart';
import 'package:chat_application_task/features/chat/data/data/models/message_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/message_entity.dart';

final chatPlatformSourceProvider = Provider<IChatPlatformSource>((ref) {
  final source = ChatPlatformSources();
  ref.onDispose(() => source.dispose());
  return source;
});

abstract interface class IChatPlatformSource {
  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageModel>> getMessages(String chatId);
}

class ChatPlatformSources implements IChatPlatformSource {
  static const MethodChannel _channel = MethodChannel(
    'com.example.chat/channel',
  );

  static const EventChannel _localMessagesChannel = EventChannel(
    'com.example.chat/local_messages',
  );

  @override
  Future<void> sendMessage(MessageEntity message) async {
    try {
      await _channel.invokeMethod('sendMessage', {
        'id': message.id,
        'chatId': message.chatId,
        'senderId': message.senderId,
        'status': message.status.name,
        'receiverId': message.receiverId,
        'content': message.content,
        'timestamp': message.timestamp.toIso8601String(),
      });
    } on PlatformException {
      rethrow;
    } catch (e) {
      Log.error('Error sending message: $e');
      rethrow;
    }
  }

  /// Yields message lists from the native EventChannel.
  /// If the channel throws a [PlatformException] (e.g. during hot-restart or
  /// rapid navigation), it retries after 500 ms automatically.
  @override
  Stream<List<MessageModel>> getMessages(String chatId) async* {
    while (true) {
      try {
        await for (final event in _localMessagesChannel.receiveBroadcastStream({
          'chatId': chatId,
        })) {
          yield (event as List<dynamic>)
              .map(
                (item) => MessageModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
        }
        return; // stream closed cleanly — stop
      } on PlatformException catch (e) {
        log('EventChannel error for $chatId: $e — retrying in 500 ms');
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  void dispose() {} // streams are cancelled automatically by their subscribers
}

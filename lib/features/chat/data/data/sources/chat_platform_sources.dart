import 'dart:developer';

import 'package:chat_application_task/core/logger/log.dart';
import 'package:chat_application_task/features/chat/data/data/models/message_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/message_entity.dart';

final chatPlatformSourceProvider = Provider<IChatPlatformSource>((ref) {
  return ChatPlatformSources();
});

abstract interface class IChatPlatformSource {
  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageModel>> getMessages(String chatId);
}

class ChatPlatformSources implements IChatPlatformSource {
  static const MethodChannel _channel = MethodChannel(
    'com.example.chat/channel',
  );
  static const EventChannel _messagesChannel = EventChannel(
    'com.example.chat/messages',
  );

  @override
  Future<void> sendMessage(MessageEntity message) async {
    try {
      log("Sending message: ----");
      await _channel.invokeMethod('sendMessage', {
        'id': message.id,
        'chatId': message.chatId,
        'senderId': message.senderId,
        'status': message.status.name,
        'receiverId': message.receiverId,
        'content': message.content,
        'timestamp': message.timestamp.toIso8601String(),
      });
      log(" Message sent successfully");
    } on PlatformException {
      rethrow;
    } catch (e) {
      Log.error('Error sending message: $e');
      rethrow;
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _messagesChannel.receiveBroadcastStream({'chatId': chatId}).map((
      event,
    ) {
      final list = event as List<dynamic>;
      return list
          .map(
            (item) =>
                MessageModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    });
  }
}

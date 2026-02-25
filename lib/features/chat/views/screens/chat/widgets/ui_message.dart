

import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';

enum MessageType { text, system }

class UiMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;

  const UiMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.type = MessageType.text,
  });

  UiMessage copyWith({
    String? id,
    String? text,
    bool? isMe,
    DateTime? timestamp,
    MessageStatus? status,
    MessageType? type,
  }) {
    return UiMessage(
      id:        id        ?? this.id,
      text:      text      ?? this.text,
      isMe:      isMe      ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
      status:    status    ?? this.status,
      type:      type      ?? this.type,
    );
  }
}

import 'package:chat_application_task/features/chat/data/data/models/message_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_entity.freezed.dart';

enum MessageStatus { pending, sent, failed }

@freezed
abstract class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    required String senderId,
    required String receiverId,
    required String chatId,
    required String content,
    required DateTime timestamp,
    required MessageStatus status,
  }) = _MessageEntity;
}

extension MessageEntityX on MessageEntity {
  toMessageModel() {
    return MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      chatId: chatId,
      content: content,
      timestamp: timestamp,
      status: status.name,
    );
  }
}

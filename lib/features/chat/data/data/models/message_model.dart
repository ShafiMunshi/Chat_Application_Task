import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String chatId,
    required String senderId,
    required String receiverId,
    required String content,
    required DateTime timestamp,
    required String status,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

extension MessageModelX on MessageModel {
 MessageEntity toMessageEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      chatId: chatId,
      content: content,
      timestamp: timestamp,
      status: MessageStatus.values.firstWhere((e) => e.name == status),
    );
  }
}

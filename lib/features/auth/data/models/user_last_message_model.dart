import 'package:chat_application_task/features/chat/domain/entities/user_last_message_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_last_message_model.freezed.dart';
part 'user_last_message_model.g.dart';

@freezed
abstract class UserLastMessageModel with _$UserLastMessageModel {
  const factory UserLastMessageModel({
    String? lastMessage,
    DateTime? timestamp,
  }) = _UserLastMessageModel;

  factory UserLastMessageModel.fromJson(Map<String, dynamic> json) =>
      _$UserLastMessageModelFromJson(json);
}

extension UserLastMessageEntityToModelX on UserLastMessageEntity {
  UserLastMessageModel toModel() {
    return UserLastMessageModel(lastMessage: content, timestamp: timestamp);
  }
}

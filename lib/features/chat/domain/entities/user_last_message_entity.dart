import 'package:chat_application_task/features/auth/data/models/user_last_message_model.dart';

class UserLastMessageEntity {
  final String content;
  final DateTime? timestamp;

  UserLastMessageEntity({required this.content, required this.timestamp});
}

extension UserLastMessageModelToEntityX on UserLastMessageModel {
  UserLastMessageEntity toEntity() {
    return UserLastMessageEntity(
      content: lastMessage ?? '',
      timestamp: timestamp,
    );
  }
}

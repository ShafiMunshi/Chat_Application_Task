import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application_task/features/chat/domain/repo/i_chat_repo.dart';

class GetChatMessagesUsecase {
  final IChatRepo repository;
  GetChatMessagesUsecase(this.repository);

  Stream<List<MessageEntity>> getMessages(String chatId) {
    return repository.getMessages(chatId);
  }
}

class SendMessageUsecase {
  final IChatRepo repository;
  SendMessageUsecase(this.repository);

  Future<void> call(MessageEntity message) async {
    return await repository.sendMessage(message);
  }
}

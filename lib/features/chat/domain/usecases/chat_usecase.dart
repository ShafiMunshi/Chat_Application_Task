import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application_task/features/chat/domain/repo/i_chat_repo.dart';
import 'package:multiple_result/multiple_result.dart';

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

  Future<Result<void, Failure>> call(MessageEntity message) async {
    return await repository.sendMessage(message);
  }
}

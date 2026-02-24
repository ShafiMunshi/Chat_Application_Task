import 'package:chat_application_task/features/chat/data/data/models/message_model.dart';
import 'package:chat_application_task/features/chat/data/data/sources/chat_remote_sources.dart';
import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application_task/features/chat/domain/repo/i_chat_repo.dart';

class ChatRepo implements IChatRepo {
  final IChatRemoteSource _chatRemoteSource;

  ChatRepo(this._chatRemoteSource);

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return _chatRemoteSource
        .getMessages(chatId)
        .map(
          (messages) =>
              messages.map((message) => message.toMessageEntity()).toList(),
        );
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    return _chatRemoteSource.sendMessage(message);
  }
}

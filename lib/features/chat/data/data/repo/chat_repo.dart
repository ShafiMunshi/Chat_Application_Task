import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/chat/data/data/models/message_model.dart';
import 'package:chat_application_task/features/chat/data/data/sources/chat_platform_sources.dart';
import 'package:chat_application_task/features/chat/data/data/sources/chat_remote_sources.dart';
import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application_task/features/chat/domain/repo/i_chat_repo.dart';
import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';

class ChatRepo implements IChatRepo {
  final IChatRemoteSource _chatRemoteSource;
  final IChatPlatformSource _chatPlatformSource;

  ChatRepo(this._chatRemoteSource, this._chatPlatformSource);

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
  Future<Result<void, Failure>> sendMessage(MessageEntity message) async {
    try {
      await _chatPlatformSource.sendMessage(message);
      return const Success(null);
    } on PlatformException catch (e) {
      return Error(Failure(message: e.message ?? 'Failed to send message'));
    }
  }
}

import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/chat/data/data/repo/chat_repo.dart';
import 'package:chat_application_task/features/chat/data/data/sources/chat_platform_sources.dart';
import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

final chatRepoProvider = Provider<IChatRepo>((ref) {
  return ChatRepo(
    ref.watch(chatPlatformSourceProvider)
  );
});

abstract interface class IChatRepo {
  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<Result<void, Failure>> sendMessage(MessageEntity message);
}

import 'package:chat_application_task/features/chat/data/data/repo/chat_repo.dart';
import 'package:chat_application_task/features/chat/data/data/sources/chat_remote_sources.dart';
import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepoProvider = Provider<IChatRepo>((ref) {
  return ChatRepo(ref.watch(chatRemoteSourceProvider));
});

abstract interface class IChatRepo {
  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<void> sendMessage(MessageEntity message);
}
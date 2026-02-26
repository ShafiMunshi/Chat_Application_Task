import 'package:chat_application_task/features/chat/data/data/repo/chat_users_repo.dart';
import 'package:chat_application_task/features/chat/domain/repo/i_chat_repo.dart';
import 'package:chat_application_task/features/chat/domain/usecases/chat_usecase.dart';
import 'package:chat_application_task/features/chat/domain/usecases/get_all_user_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getChatUsersUsecaseProvider = Provider<GetAllUserUsecase>((ref) {
  final chatUsersRepo = ref.watch(chatUsersRepoProvider);
  return GetAllUserUsecase(chatUsersRepo);
});

final getUserByIdUsecaseProvider = Provider<GetUserByIdUsecase>((ref) {
  final chatUsersRepo = ref.watch(chatUsersRepoProvider);
  return GetUserByIdUsecase(chatUsersRepo);
});

final getUserLastMessageUsecaseProvider = Provider<GetUserLastMessageUsecase>((
  ref,
) {
  final chatUsersRepo = ref.watch(chatUsersRepoProvider);
  return GetUserLastMessageUsecase(chatUsersRepo);
});

final getChatMessagesUsecaseProvider = Provider<GetChatMessagesUsecase>((ref) {
  final chatRepo = ref.watch(chatRepoProvider);
  return GetChatMessagesUsecase(chatRepo);
});

final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  final chatRepo = ref.read(chatRepoProvider);
  return SendMessageUsecase(chatRepo);
});

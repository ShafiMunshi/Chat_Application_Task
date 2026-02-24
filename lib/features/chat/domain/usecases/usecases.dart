import 'package:chat_application_task/features/chat/data/data/repo/chat_users_repo.dart';
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
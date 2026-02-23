import 'package:chat_application_task/features/auth/data/repo/auth_repo.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepoProvider);
  return repo.authStateChanges();
});

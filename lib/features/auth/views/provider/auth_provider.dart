import 'package:chat_application_task/features/auth/data/repo/auth_repo.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepoProvider);
  return repo.authStateChanges();
});

final signOutProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(authRepoProvider);
  final result = await repo.signOut();

  return result.when((data) => data, (error) => throw Exception(error.message));
});

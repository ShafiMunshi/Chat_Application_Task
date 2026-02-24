import 'package:chat_application_task/features/auth/data/repo/auth_repo.dart';
import 'package:chat_application_task/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:chat_application_task/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:chat_application_task/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInUsecaseProvider = Provider<SignInUseCase>((ref) {
  final authRepo = ref.read(authRepoProvider);
  return SignInUseCase(authRepo);
});

final signUpUsecaseProvider = Provider<SignUpUseCase>((ref) {
  final authRepo = ref.read(authRepoProvider);
  return SignUpUseCase(authRepo);
});

final signOutUsecaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepo = ref.read(authRepoProvider);
  return SignOutUseCase(authRepo);
});

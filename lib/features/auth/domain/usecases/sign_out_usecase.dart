import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/domain/repo/iauth_repo.dart';
import 'package:multiple_result/multiple_result.dart';

final class SignOutUseCase {
  SignOutUseCase(this.repository);

  final IAuthRepo repository;

  Future<Result<void, Failure>> call() async {
    return await repository.signOut();
  }
}

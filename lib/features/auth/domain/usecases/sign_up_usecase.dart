import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_up_entity.dart';
import 'package:chat_application_task/features/auth/domain/repo/iauth_repo.dart';
import 'package:multiple_result/src/result.dart';

final class RegisterUseCase {
  RegisterUseCase(this.repository);

  final IAuthRepo repository;

  Future<Result<SignUpResponseEntity, Failure>> call(
    SignUpRequestEntity request,
  ) async {
    return await repository.signUp(request);
  }
}

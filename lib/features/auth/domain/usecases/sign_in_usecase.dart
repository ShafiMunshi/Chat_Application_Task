import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_in_entity.dart';
import 'package:chat_application_task/features/auth/domain/repo/iauth_repo.dart';
import 'package:multiple_result/multiple_result.dart';

final class SignInUseCase {
  SignInUseCase(this.repository);

  final IAuthRepo repository;

  Future<Result<SignInResponseEntity, Failure>> call(
     SignInRequestEntity request,
  ) async {
    return await repository.signIn(request);
  }
}

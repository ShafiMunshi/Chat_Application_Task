import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_in_entity.dart';
import 'package:chat_application_task/features/auth/domain/repo/iauth_repo.dart';
import 'package:multiple_result/multiple_result.dart';

final class LoginUseCase {
  LoginUseCase(this.repository);

  final IAuthRepo repository;

  Future<Result<SignInResponseEntity, Failure>> call({
    required String email,
    required String password,
    bool? shouldRemember,
  }) async {
    final request = SignInRequestEntity(email: email, password: password);
    return await repository.signIn(request);
  }
}

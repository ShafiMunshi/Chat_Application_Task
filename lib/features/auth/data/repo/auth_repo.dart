import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/data/models/user_model.dart';
import 'package:chat_application_task/features/auth/data/sources/remote_auth_source.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_in_entity.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_up_entity.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:chat_application_task/features/auth/domain/repo/iauth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

final authRepoProvider = Provider<IAuthRepo>((ref) {
  final remoteDataSource = ref.watch(authRemoteSourceProvider);
  return AuthRepo(remoteDataSource);
});

class AuthRepo implements IAuthRepo {
  final IAuthRemoteSource remoteDataSource;

  AuthRepo(this.remoteDataSource);
  @override
  Future<Result<SignInResponseEntity, Failure>> signIn(
    SignInRequestEntity signInEntity,
  ) async {
    try {
      final userModel = await remoteDataSource.signIn({
        'email': signInEntity.email,
        'password': signInEntity.password,
      });

      return Success(userModel.toSignInResponseEntity());
    } on Exception catch (e) {
      return Error(Failure.mapExceptionToFailure(e));
    } catch (e) {
      return const Error(Failure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Result<SignUpResponseEntity, Failure>> signUp(
    SignUpRequestEntity signUpEntity,
  ) async {
    try {
      final userModel = await remoteDataSource.signUp({
        'name': signUpEntity.name,
        'email': signUpEntity.email,
        'password': signUpEntity.password,
      });

      return Success(userModel.toSignUpResponseEntity());
    } on Exception catch (e) {
      return Error(Failure.mapExceptionToFailure(e));
    } catch (e) {
      return const Error(Failure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Success(null);
    } on Exception catch (e) {
      return Error(Failure.mapExceptionToFailure(e));
    } catch (e) {
      return const Error(Failure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }
}

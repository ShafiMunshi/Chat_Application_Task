import 'package:chat_application_task/core/errors/failures.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_in_entity.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_up_entity.dart';
import 'package:multiple_result/multiple_result.dart';

abstract interface class IAuthRepo {
  Future<Result<SignInResponseEntity, Failure>> signIn(SignInRequestEntity signInEntity);
  Future<Result<SignUpResponseEntity, Failure>> signUp(SignUpRequestEntity signUpEntity);
}

import 'package:chat_application_task/features/auth/domain/entities/sign_in_entity.dart';
import 'package:chat_application_task/features/auth/domain/entities/sign_up_entity.dart';
import 'package:chat_application_task/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    required String email,
    required String uid,
    String? profilePictureUrl,
    required String refreshToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  SignInResponseEntity toSignInResponseEntity() {
    return SignInResponseEntity(
      token: refreshToken,
      isSignInSuccess: uid.isNotEmpty,
    );
  }

  SignUpResponseEntity toSignUpResponseEntity() {
    return SignUpResponseEntity(
      token: refreshToken,
      isSignUpSuccess: uid.isNotEmpty,
    );
  }

  UserEntity toUserEntity() {
    return UserEntity(
      id: uid,
      name: name,
      email: email,
      profilePictureUrl: profilePictureUrl,
    );
  }
}

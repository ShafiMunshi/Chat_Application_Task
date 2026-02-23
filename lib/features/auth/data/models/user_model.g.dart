// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  name: json['name'] as String,
  email: json['email'] as String,
  uid: json['uid'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'uid': instance.uid,
      'profilePictureUrl': instance.profilePictureUrl,
      'refreshToken': instance.refreshToken,
    };

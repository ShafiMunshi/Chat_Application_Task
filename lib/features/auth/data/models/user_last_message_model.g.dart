// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_last_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLastMessageModel _$UserLastMessageModelFromJson(
  Map<String, dynamic> json,
) => _UserLastMessageModel(
  lastMessage: json['lastMessage'] as String?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$UserLastMessageModelToJson(
  _UserLastMessageModel instance,
) => <String, dynamic>{
  'lastMessage': instance.lastMessage,
  'timestamp': instance.timestamp?.toIso8601String(),
};

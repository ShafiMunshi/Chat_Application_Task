import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_entity.freezed.dart';

enum MessageStatus { pending, sent, failed }

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String senderId,
    required String text,
    required DateTime timestamp,
    required MessageStatus status,
  }) = _Message;
}

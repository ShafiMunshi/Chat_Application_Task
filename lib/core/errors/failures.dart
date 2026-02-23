import 'package:chat_application_task/core/errors/exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure({required String message}) = _Failure;

  factory Failure.mapExceptionToFailure(Object e) {
    if (e is Exception) {
      return switch (e) {
        ServerException() => Failure(message: e.message),
        ParsingException() => Failure(message: e.message),
        ValidationException() => Failure(message: e.message),
        NotFoundException() => Failure(message: e.message),
        NetworkException() => const Failure(
          message:
              'Unable to connect.'
              'Please check your internet connection and try again.',
        ),
        _ => Failure(message: e.toString()),
      };
    }

    if (e is Error) {
      return switch (e) {
        TypeError() => Failure(message: 'Type mismatch: ${e.toString()}'),
        _ => Failure(message: e.toString()),
      };
    }

    return Failure(message: e.toString());
  }
}

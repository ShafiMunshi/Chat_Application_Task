import 'package:chat_application_task/core/errors/exceptions.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseExceptionsMapper {
  static Exception mapFirebaseException(FirebaseException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return AuthenticationException(
          message: "No user found with the provided credentials. Please check your email and password and try again.",
        );
      case 'wrong-password':
      case 'invalid-email':
      case 'invalid-credential':
      case 'user-disabled':
        return AuthenticationException(
          message: "Email or password is incorrect. Please try again.",
        );

      case 'permission-denied':
        return PermissionDeniedException(
          message: exception.message ?? 'Permission denied',
        );

      case 'not-found':
        return NotFoundException(message:  exception.message ?? 'Resource not found');

      case 'unavailable':
      case 'network-request-failed':
        return NetworkException(message: exception.message ?? 'Network error');

      case 'internal':
      case 'unknown':
        return ServerException(message: exception.message ?? 'Server error');

      default:
        return UnknownException(
          message: exception.message ?? 'An unexpected error occurred',
        );
    }
  }


}

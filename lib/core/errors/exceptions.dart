/// Custom exception for server errors
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() =>
      'ServerException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}

/// Custom exception for cache errors
class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

/// Custom exception for network errors
class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

/// Custom exception for authentication errors
class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({required this.message});

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Custom exception for validation errors
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException({required this.message, this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

/// Custom exception for not found errors
class NotFoundException implements Exception {
  final String message;

  NotFoundException({required this.message});

  @override
  String toString() => 'NotFoundException: $message';
}

/// Custom exception for generic errors
class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => 'AppException: $message';
}

class ParsingException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  ParsingException({required this.message, this.stackTrace});

  @override
  String toString() => 'ParsingException: $message';
}


class PermissionDeniedException implements Exception {
  final String message;

  PermissionDeniedException({required this.message});

  @override
  String toString() => 'PermissionDeniedException: $message';
}

class UnknownException implements Exception {
  final String message;

  UnknownException({required this.message});

  @override
  String toString() => 'UnknownException: $message';
}
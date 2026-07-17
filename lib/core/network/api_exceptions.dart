class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({required this.message, this.statusCode, this.errorCode});

  @override
  String toString() => 'ApiException: $message (code: $errorCode, status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException([String message = 'No internet connection'])
      : super(message: message);
}

class AuthException extends ApiException {
  AuthException(String message) : super(message: message, statusCode: 401);
}

class ValidationException extends ApiException {
  final Map<String, String?>? fieldErrors;
  ValidationException(String message, {this.fieldErrors})
      : super(message: message, statusCode: 422);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message: message, statusCode: 500);
}

class DuplicateException extends ApiException {
  DuplicateException(String message) : super(message: message, statusCode: 409);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message: message, statusCode: 404);
}

class PermissionDeniedException extends ApiException {
  PermissionDeniedException() : super(message: 'Permission denied', statusCode: 403);
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import 'api_exceptions.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
    }
    handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(),
          type: err.type,
        ),
      );
      return;
    }

    if (err.type == DioExceptionType.connectionError) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(),
          type: err.type,
        ),
      );
      return;
    }

    final response = err.response;
    if (response != null) {
      final data = response.data;
      final message = data?['message'] ?? 'Something went wrong';
      final errorCode = data?['error']?['code'] ?? data?['error_code'];

      switch (response.statusCode) {
        case 401:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: AuthException(message),
              response: response,
              type: err.type,
            ),
          );
          return;
        case 403:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: PermissionDeniedException(),
              response: response,
              type: err.type,
            ),
          );
          return;
        case 404:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: NotFoundException(message),
              response: response,
              type: err.type,
            ),
          );
          return;
        case 409:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: DuplicateException(message),
              response: response,
              type: err.type,
            ),
          );
          return;
        case 422:
          final fieldErrors = _parseFieldErrors(data);
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ValidationException(message, fieldErrors: fieldErrors),
              response: response,
              type: err.type,
            ),
          );
          return;
        default:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ServerException(message),
              response: response,
              type: err.type,
            ),
          );
      }
    }
    handler.next(err);
  }

  Map<String, String?>? _parseFieldErrors(dynamic data) {
    if (data is Map && data.containsKey('detail')) {
      final detail = data['detail'];
      if (detail is List) {
        final errors = <String, String?>{};
        for (final d in detail) {
          if (d is Map) {
            final loc = d['loc'];
            final field = loc is List && loc.length > 1 ? loc.last.toString() : null;
            if (field != null) {
              errors[field] = d['msg'];
            }
          }
        }
        return errors;
      }
    }
    return null;
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

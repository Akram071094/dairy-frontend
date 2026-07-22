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

class ResponseEnvelopeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic>) {
      final body = response.data as Map<String, dynamic>;
      if (body.containsKey('success') && body.containsKey('data')) {
        response.data = body['data'];
      }
    }
    handler.next(response);
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
          error: NetworkException('Connection timed out. Check your internet or if the backend is awake.'),
          type: err.type,
        ),
      );
      return;
    }

    if (err.type == DioExceptionType.connectionError) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(
            'Cannot reach the server (${err.message ?? 'connection failed'}). '
            'Verify the phone has internet and can reach the backend URL.',
          ),
          type: err.type,
        ),
      );
      return;
    }

    final response = err.response;
    if (response != null) {
      final data = response.data;
      final errorObj = data is Map ? data['error'] : null;
      final message = errorObj is Map
          ? (errorObj['message'] ?? data['message'] ?? 'Something went wrong')
          : (data is Map ? data['message'] ?? 'Something went wrong' : 'Something went wrong');

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
    if (data is Map) {
      final errorObj = data['error'];
      if (errorObj is Map && errorObj.containsKey('details')) {
        final details = errorObj['details'];
        if (details is List) {
          final errors = <String, String?>{};
          for (final d in details) {
            if (d is Map) {
              final field = d['field']?.toString();
              if (field != null) {
                errors[field] = d['message']?.toString();
              }
            }
          }
          return errors;
        }
      }
      if (data.containsKey('detail')) {
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

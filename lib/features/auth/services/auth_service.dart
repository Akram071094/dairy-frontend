import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/constants/api_constants.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/auth/models/auth_models.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<SignupResponse> signup(SignupRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.signup,
        data: request.toJson(),
      );
      return SignupResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.get(ApiConstants.me);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken(String token) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.refresh,
        data: {'refresh_token': token},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException();
    }
    if (e.type == DioExceptionType.connectionError) {
      return NetworkException();
    }
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = _extractMessage(e.response!.data);
      switch (statusCode) {
        case 401:
          return AuthException(message);
        case 403:
          return PermissionDeniedException();
        case 404:
          return NotFoundException(message);
        case 409:
          return DuplicateException(message);
        case 422:
          return ValidationException(message);
        case 500:
          return ServerException(message);
        default:
          return ApiException(message: message, statusCode: statusCode);
      }
    }
    return ApiException(message: e.message ?? 'An unexpected error occurred');
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['detail'] != null) return data['detail'].toString();
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    return 'An unexpected error occurred';
  }
}

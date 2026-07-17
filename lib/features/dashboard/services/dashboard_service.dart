import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/constants/api_constants.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/dashboard/models/dashboard_models.dart';

class DashboardService {
  final ApiClient _client;

  DashboardService({required ApiClient apiClient}) : _client = apiClient;

  Future<DashboardSummary> getSummary() async {
    try {
      final response = await _client.get('${ApiConstants.apiPrefix}/dashboard/summary');
      return DashboardSummary.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RecentActivity>> getRecentActivity() async {
    try {
      final response = await _client.get('${ApiConstants.apiPrefix}/dashboard/recent-activity');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => RecentActivity.fromJson(e as Map<String, dynamic>))
          .toList();
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

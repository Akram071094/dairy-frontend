import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/recommendations/models/recommendation_models.dart';

class RecommendationService {
  final ApiClient _client;
  RecommendationService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/recommendations';

  Future<List<Recommendation>> generateRecommendations({String? entityType, String? entityId}) async {
    try {
      final data = <String, dynamic>{};
      if (entityType != null) data['entity_type'] = entityType;
      if (entityId != null) data['entity_id'] = entityId;
      final response = await _client.post('$_base/generate', data: data);
      final resData = response.data;
      final list = (resData is Map && resData['data'] is List) ? resData['data'] as List : resData as List;
      return list.map((e) => Recommendation.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Recommendation> getRecommendation(String id) async {
    try {
      final response = await _client.get('$_base/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Recommendation.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Recommendation.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Recommendation>> getRecommendations({int? page, int? limit, String? status}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (status != null) queryParameters['status'] = status;
      final response = await _client.get(_base, queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Recommendation.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> approveRecommendation(String id) async {
    try {
      await _client.post('$_base/$id/approve');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> rejectRecommendation(String id, {String? reason}) async {
    try {
      final data = <String, dynamic>{};
      if (reason != null) data['reason'] = reason;
      await _client.post('$_base/$id/reject', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ManagerFeedback> submitFeedback(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.post('$_base/$id/feedback', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return ManagerFeedback.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return ManagerFeedback.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ManagerFeedback>> getFeedback(String id) async {
    try {
      final response = await _client.get('$_base/$id/feedback');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => ManagerFeedback.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getRecommendationHistory(String id) async {
    try {
      final response = await _client.get('$_base/$id/history');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.cast<Map<String, dynamic>>();
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

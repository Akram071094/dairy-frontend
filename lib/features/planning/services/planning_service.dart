import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/planning/models/planning_models.dart';

class PlanningService {
  final ApiClient _client;
  PlanningService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/planning';

  Future<PlanningBatch> generatePlan({DateTime? date, String? session}) async {
    try {
      final data = <String, dynamic>{};
      if (date != null) data['date'] = date.toIso8601String().split('T').first;
      if (session != null) data['session'] = session;
      final response = await _client.post('$_base/generate', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return PlanningBatch.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return PlanningBatch.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlanningBatch> getPlan(String id) async {
    try {
      final response = await _client.get('$_base/plans/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return PlanningBatch.fromJson(data['data'] as Map<String, dynamic>);
      }
      return PlanningBatch.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> reviewPlan(String id) async {
    try {
      await _client.post('$_base/plans/$id/review');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> approvePlan(String id) async {
    try {
      await _client.post('$_base/plans/$id/approve');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> regeneratePlan(String id) async {
    try {
      await _client.post('$_base/plans/$id/regenerate');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> cancelPlan(String id) async {
    try {
      await _client.post('$_base/plans/$id/cancel');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DeliveryManifest> getManifest(String planId) async {
    try {
      final response = await _client.get('$_base/plans/$planId/manifest');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return DeliveryManifest.fromJson(data['data'] as Map<String, dynamic>);
      }
      return DeliveryManifest.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateManifestItem(String manifestId, String itemId, Map<String, dynamic> data) async {
    try {
      await _client.patch('$_base/manifests/$manifestId/items/$itemId', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlanningSummary> getPlanSummary(String planId) async {
    try {
      final response = await _client.get('$_base/plans/$planId/summary');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return PlanningSummary.fromJson(data['data'] as Map<String, dynamic>);
      }
      return PlanningSummary.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PlanningException>> getExceptions(String planId) async {
    try {
      final response = await _client.get('$_base/plans/$planId/exceptions');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => PlanningException.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resolveException(String exceptionId, Map<String, dynamic> data) async {
    try {
      await _client.post('$_base/exceptions/$exceptionId/resolve', data: data);
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

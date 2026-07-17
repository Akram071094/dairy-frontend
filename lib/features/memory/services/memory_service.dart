import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/memory/models/memory_models.dart';

class MemoryService {
  final ApiClient _client;
  MemoryService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/memory';

  Future<BusinessObservation> createObservation(Map<String, dynamic> data) async {
    try {
      final response = await _client.post('$_base/observations', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return BusinessObservation.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return BusinessObservation.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BusinessObservation> getObservation(String id) async {
    try {
      final response = await _client.get('$_base/observations/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return BusinessObservation.fromJson(data['data'] as Map<String, dynamic>);
      }
      return BusinessObservation.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<BusinessObservation>> getObservations({String? entityType, String? entityId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (entityType != null) queryParameters['entity_type'] = entityType;
      if (entityId != null) queryParameters['entity_id'] = entityId;
      final response = await _client.get('$_base/observations', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => BusinessObservation.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BusinessPattern> createPattern(Map<String, dynamic> data) async {
    try {
      final response = await _client.post('$_base/patterns', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return BusinessPattern.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return BusinessPattern.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BusinessPattern> getPattern(String id) async {
    try {
      final response = await _client.get('$_base/patterns/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return BusinessPattern.fromJson(data['data'] as Map<String, dynamic>);
      }
      return BusinessPattern.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<BusinessPattern>> getPatterns({String? entityType, String? entityId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (entityType != null) queryParameters['entity_type'] = entityType;
      if (entityId != null) queryParameters['entity_id'] = entityId;
      final response = await _client.get('$_base/patterns', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => BusinessPattern.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ManagerDecision> createDecision(Map<String, dynamic> data) async {
    try {
      final response = await _client.post('$_base/decisions', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return ManagerDecision.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return ManagerDecision.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ManagerDecision> getDecision(String id) async {
    try {
      final response = await _client.get('$_base/decisions/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return ManagerDecision.fromJson(data['data'] as Map<String, dynamic>);
      }
      return ManagerDecision.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ManagerDecision>> getDecisions({String? entityType, String? entityId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (entityType != null) queryParameters['entity_type'] = entityType;
      if (entityId != null) queryParameters['entity_id'] = entityId;
      final response = await _client.get('$_base/decisions', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => ManagerDecision.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getBehaviours(String entityType, String entityId) async {
    try {
      final response = await _client.get('$_base/behaviours/$entityType/$entityId');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Knowledge> getKnowledge(String entityType, String entityId) async {
    try {
      final response = await _client.get('$_base/knowledge/$entityType/$entityId');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Knowledge.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Knowledge.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> searchKnowledge(String query) async {
    try {
      final response = await _client.get('$_base/knowledge/search', queryParameters: {
        'q': query,
      });
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

import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/delivery/models/delivery_models.dart';

class DeliveryService {
  final ApiClient _client;
  DeliveryService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/delivery';

  Future<ManifestAssignment> assignManifest(String manifestId, String staffId) async {
    try {
      final response = await _client.post('$_base/manifests/$manifestId/assign', data: {
        'staff_id': staffId,
      });
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return ManifestAssignment.fromJson(data['data'] as Map<String, dynamic>);
      }
      return ManifestAssignment.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> reassignStaff(String assignmentId, String newStaffId) async {
    try {
      await _client.post('$_base/assignments/$assignmentId/reassign', data: {
        'staff_id': newStaffId,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> acceptAssignment(String id) async {
    try {
      await _client.post('$_base/assignments/$id/accept');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> rejectAssignment(String id, {String? reason}) async {
    try {
      final data = <String, dynamic>{};
      if (reason != null) data['reason'] = reason;
      await _client.post('$_base/assignments/$id/reject', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> startAssignment(String id) async {
    try {
      await _client.post('$_base/assignments/$id/start');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> completeAssignment(String id) async {
    try {
      await _client.post('$_base/assignments/$id/complete');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ManifestAssignment> getAssignment(String id) async {
    try {
      final response = await _client.get('$_base/assignments/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return ManifestAssignment.fromJson(data['data'] as Map<String, dynamic>);
      }
      return ManifestAssignment.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ManifestAssignment>> getMyAssignments() async {
    try {
      final response = await _client.get('$_base/assignments/my');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => ManifestAssignment.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ManifestAssignment>> getAssignments({int? page, int? limit}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      final response = await _client.get('$_base/assignments', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => ManifestAssignment.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<AssignmentHistory>> getAssignmentHistory(String id) async {
    try {
      final response = await _client.get('$_base/assignments/$id/history');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => AssignmentHistory.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<AssignmentActivity>> getAssignmentActivity(String id) async {
    try {
      final response = await _client.get('$_base/assignments/$id/activity');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => AssignmentActivity.fromJson(e as Map<String, dynamic>)).toList();
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

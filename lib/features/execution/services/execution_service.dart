import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/execution/models/execution_models.dart';

class ExecutionService {
  final ApiClient _client;
  ExecutionService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/execution';

  Future<SupplyExecution> startExecution(String assignmentId) async {
    try {
      final response = await _client.post('$_base/start', data: {
        'assignment_id': assignmentId,
      });
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return SupplyExecution.fromJson(data['data'] as Map<String, dynamic>);
      }
      return SupplyExecution.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> completeExecution(String id) async {
    try {
      await _client.post('$_base/executions/$id/complete');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<SupplyExecution> getExecution(String id) async {
    try {
      final response = await _client.get('$_base/executions/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return SupplyExecution.fromJson(data['data'] as Map<String, dynamic>);
      }
      return SupplyExecution.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<SupplyExecution>> getMyExecutions() async {
    try {
      final response = await _client.get('$_base/executions/my');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => SupplyExecution.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RetailerVisit> startVisit(String executionId, String visitId) async {
    try {
      final response = await _client.post('$_base/executions/$executionId/visits/$visitId/start');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return RetailerVisit.fromJson(data['data'] as Map<String, dynamic>);
      }
      return RetailerVisit.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RetailerVisit> completeVisit(String executionId, String visitId, Map<String, dynamic> data) async {
    try {
      final response = await _client.post('$_base/executions/$executionId/visits/$visitId/complete', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return RetailerVisit.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return RetailerVisit.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> skipVisit(String executionId, String visitId, {String? reason}) async {
    try {
      final data = <String, dynamic>{};
      if (reason != null) data['reason'] = reason;
      await _client.post('$_base/executions/$executionId/visits/$visitId/skip', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RetailerVisit> getVisit(String executionId, String visitId) async {
    try {
      final response = await _client.get('$_base/executions/$executionId/visits/$visitId');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return RetailerVisit.fromJson(data['data'] as Map<String, dynamic>);
      }
      return RetailerVisit.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordDelivery(String executionId, String visitId, List<Map<String, dynamic>> items) async {
    try {
      await _client.post('$_base/executions/$executionId/visits/$visitId/delivery', data: {
        'items': items,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordAdditionalSale(String executionId, String visitId, List<Map<String, dynamic>> sales) async {
    try {
      await _client.post('$_base/executions/$executionId/visits/$visitId/additional-sales', data: {
        'sales': sales,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordReturn(String executionId, String visitId, List<Map<String, dynamic>> returns) async {
    try {
      await _client.post('$_base/executions/$executionId/visits/$visitId/returns', data: {
        'returns': returns,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordException(String executionId, String visitId, Map<String, dynamic> exception) async {
    try {
      await _client.post('$_base/executions/$executionId/visits/$visitId/exceptions', data: exception);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getExecutionSummary(String id) async {
    try {
      final response = await _client.get('$_base/executions/$id/summary');
      return response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RetailerVisit>> getVisits(String executionId) async {
    try {
      final response = await _client.get('$_base/executions/$executionId/visits');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => RetailerVisit.fromJson(e as Map<String, dynamic>)).toList();
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

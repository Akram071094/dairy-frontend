import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/supply_config/models/supply_config_models.dart';

class SupplyConfigService {
  final ApiClient _client;
  SupplyConfigService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/supply-config';

  Future<SupplyConfiguration> getSupplyConfig(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return SupplyConfiguration.fromJson(data['data'] as Map<String, dynamic>);
      }
      return SupplyConfiguration.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<SupplyConfiguration> createSupplyConfig(String retailerId, SupplyConfigCreateRequest req) async {
    try {
      final response = await _client.post('$_base/$retailerId', data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return SupplyConfiguration.fromJson(data['data'] as Map<String, dynamic>);
      }
      return SupplyConfiguration.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateSupplyConfig(String retailerId, Map<String, dynamic> data) async {
    try {
      await _client.patch('$_base/$retailerId', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<StandingOrder>> getStandingOrders(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId/standing-orders');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => StandingOrder.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<StandingOrder> createStandingOrder(String retailerId, StandingOrderCreateRequest req) async {
    try {
      final response = await _client.post('$_base/$retailerId/standing-orders', data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return StandingOrder.fromJson(data['data'] as Map<String, dynamic>);
      }
      return StandingOrder.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<StandingOrder> updateStandingOrder(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch('/api/v1/standing-orders/$id', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return StandingOrder.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return StandingOrder.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteStandingOrder(String id) async {
    try {
      await _client.delete('/api/v1/standing-orders/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> suspendStandingOrder(String id) async {
    try {
      await _client.post('/api/v1/standing-orders/$id/suspend');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resumeStandingOrder(String id) async {
    try {
      await _client.post('/api/v1/standing-orders/$id/resume');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<DailyOrder>> getDailyOrders(String retailerId, {DateTime? date}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (date != null) queryParameters['date'] = date.toIso8601String().split('T').first;
      final response = await _client.get('$_base/$retailerId/daily-orders', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => DailyOrder.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DailyOrder> createDailyOrder(String retailerId, DailyOrderCreateRequest req) async {
    try {
      final response = await _client.post('$_base/$retailerId/daily-orders', data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return DailyOrder.fromJson(data['data'] as Map<String, dynamic>);
      }
      return DailyOrder.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> confirmDailyOrder(String id) async {
    try {
      await _client.post('/api/v1/daily-orders/$id/confirm');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> cancelDailyOrder(String id) async {
    try {
      await _client.post('/api/v1/daily-orders/$id/cancel');
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

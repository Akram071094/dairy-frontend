import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/inventory/models/inventory_models.dart';

class InventoryService {
  final ApiClient _client;
  InventoryService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/inventory';

  Future<Inventory> getInventory(String skuId) async {
    try {
      final response = await _client.get('$_base/$skuId');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Inventory.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Inventory.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Inventory>> getInventoryList({int? page, int? limit, String? search}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (search != null) queryParameters['search'] = search;
      final response = await _client.get(_base, queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Inventory.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addOpeningStock(Map<String, dynamic> data) async {
    try {
      await _client.post('$_base/opening-stock', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordStockIn(Map<String, dynamic> data) async {
    try {
      await _client.post('$_base/stock-in', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordStockOut(Map<String, dynamic> data) async {
    try {
      await _client.post('$_base/stock-out', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordReturn(Map<String, dynamic> data) async {
    try {
      await _client.post('$_base/returns', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> adjustStock(String skuId, Map<String, dynamic> data) async {
    try {
      await _client.patch('$_base/$skuId/adjust', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<StockMovement>> getStockMovements(String skuId, {int? page, int? limit}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      final response = await _client.get('$_base/$skuId/movements', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => StockMovement.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<InventorySummary> getInventorySummary() async {
    try {
      final response = await _client.get('$_base/summary');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return InventorySummary.fromJson(data['data'] as Map<String, dynamic>);
      }
      return InventorySummary.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Inventory>> getLowStock() async {
    try {
      final response = await _client.get('$_base/low-stock');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Inventory.fromJson(e as Map<String, dynamic>)).toList();
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

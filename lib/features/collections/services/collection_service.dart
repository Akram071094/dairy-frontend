import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/collections/models/collection_models.dart';

class CollectionService {
  final ApiClient _client;
  CollectionService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/collections';

  Future<Collection> collectPayment(Map<String, dynamic> data) async {
    try {
      final response = await _client.post(_base, data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return Collection.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return Collection.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Collection> getCollection(String id) async {
    try {
      final response = await _client.get('$_base/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Collection.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Collection.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Collection>> getCollections({int? page, int? limit, String? retailerId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (retailerId != null) queryParameters['retailer_id'] = retailerId;
      final response = await _client.get(_base, queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Collection.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Collection> adjustCollection(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch('$_base/$id', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return Collection.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return Collection.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Outstanding> getOutstanding(String retailerId) async {
    try {
      final response = await _client.get('$_base/outstanding/$retailerId');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Outstanding.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Outstanding.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Outstanding>> getOutstandingSummary() async {
    try {
      final response = await _client.get('$_base/outstanding');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Outstanding.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Outstanding> adjustOutstanding(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch('$_base/outstanding/$id', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return Outstanding.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return Outstanding.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Credit> getCredit(String retailerId) async {
    try {
      final response = await _client.get('$_base/credit/$retailerId');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Credit.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Credit.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Credit>> getCreditSummary() async {
    try {
      final response = await _client.get('$_base/credit');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Credit.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Credit> adjustCredit(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch('$_base/credit/$id', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return Credit.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return Credit.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<CollectionException>> getExceptions({String? retailerId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (retailerId != null) queryParameters['retailer_id'] = retailerId;
      final response = await _client.get('$_base/exceptions', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => CollectionException.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resolveException(String id, Map<String, dynamic> data) async {
    try {
      await _client.post('$_base/exceptions/$id/resolve', data: data);
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

import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/products/models/product_models.dart';

class ProductService {
  final ApiClient _client;
  ProductService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/products';

  Future<List<ProductFamily>> getProductFamilies({int? page, int? limit, String? search}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (search != null) queryParameters['search'] = search;
      final response = await _client.get('$_base/families', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => ProductFamily.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductFamily> getProductFamily(String id) async {
    try {
      final response = await _client.get('$_base/families/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return ProductFamily.fromJson(data['data'] as Map<String, dynamic>);
      }
      return ProductFamily.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductFamily> createProductFamily(ProductFamilyCreateRequest req) async {
    try {
      final response = await _client.post('$_base/families', data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return ProductFamily.fromJson(data['data'] as Map<String, dynamic>);
      }
      return ProductFamily.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductFamily> updateProductFamily(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch('$_base/families/$id', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return ProductFamily.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return ProductFamily.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> archiveProductFamily(String id) async {
    try {
      await _client.post('$_base/families/$id/archive');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> activateProductFamily(String id) async {
    try {
      await _client.post('$_base/families/$id/activate');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ProductSKU>> getProductSKUs({int? page, int? limit, String? search, String? familyId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (search != null) queryParameters['search'] = search;
      if (familyId != null) queryParameters['family_id'] = familyId;
      final response = await _client.get('$_base/skus', queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => ProductSKU.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductSKU> getProductSKU(String id) async {
    try {
      final response = await _client.get('$_base/skus/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return ProductSKU.fromJson(data['data'] as Map<String, dynamic>);
      }
      return ProductSKU.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductSKU> createProductSKU(ProductSKUCreateRequest req) async {
    try {
      final response = await _client.post('$_base/skus', data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return ProductSKU.fromJson(data['data'] as Map<String, dynamic>);
      }
      return ProductSKU.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductSKU> updateProductSKU(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch('$_base/skus/$id', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return ProductSKU.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return ProductSKU.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<MeasurementUnit>> getMeasurementUnits() async {
    try {
      final response = await _client.get('$_base/measurement-units');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => MeasurementUnit.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PackageType>> getPackageTypes() async {
    try {
      final response = await _client.get('$_base/package-types');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => PackageType.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ProductCategory>> getProductCategories() async {
    try {
      final response = await _client.get('$_base/categories');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => ProductCategory.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Pricing>> getPricing(String skuId) async {
    try {
      final response = await _client.get('$_base/skus/$skuId/pricing');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Pricing.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updatePricing(String skuId, PricingUpdateRequest req) async {
    try {
      await _client.patch('$_base/skus/$skuId/pricing', data: req.toJson());
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

import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/retailers/models/retailer_models.dart';

class RetailerService {
  final ApiClient _client;
  RetailerService({required ApiClient apiClient}) : _client = apiClient;

  static const _base = '/api/v1/retailers';

  Future<List<Retailer>> getRetailers({int? page, int? limit, String? search}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (search != null) queryParameters['search'] = search;
      final response = await _client.get(_base, queryParameters: queryParameters);
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => Retailer.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Retailer> getRetailer(String id) async {
    try {
      final response = await _client.get('$_base/$id');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Retailer.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Retailer.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Retailer> createRetailer(RetailerCreateRequest req) async {
    try {
      final response = await _client.post(_base, data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Retailer.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Retailer.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Retailer> updateRetailer(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch('$_base/$id', data: data);
      final resData = response.data;
      if (resData is Map<String, dynamic> && resData.containsKey('data')) {
        return Retailer.fromJson(resData['data'] as Map<String, dynamic>);
      }
      return Retailer.fromJson(resData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> archiveRetailer(String id) async {
    try {
      await _client.post('$_base/$id/archive');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> activateRetailer(String id) async {
    try {
      await _client.post('$_base/$id/activate');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RetailerContact>> getContacts(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId/contacts');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => RetailerContact.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RetailerContact> addContact(String retailerId, RetailerContactRequest req) async {
    try {
      final response = await _client.post('$_base/$retailerId/contacts', data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return RetailerContact.fromJson(data['data'] as Map<String, dynamic>);
      }
      return RetailerContact.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateContact(String retailerId, String contactId, Map<String, dynamic> data) async {
    try {
      await _client.patch('$_base/$retailerId/contacts/$contactId', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteContact(String retailerId, String contactId) async {
    try {
      await _client.delete('$_base/$retailerId/contacts/$contactId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RetailerAddress>> getAddresses(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId/addresses');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => RetailerAddress.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RetailerAddress> addAddress(String retailerId, RetailerAddressRequest req) async {
    try {
      final response = await _client.post('$_base/$retailerId/addresses', data: req.toJson());
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return RetailerAddress.fromJson(data['data'] as Map<String, dynamic>);
      }
      return RetailerAddress.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DeliveryPreferences> getDeliveryPreferences(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId/delivery-preferences');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return DeliveryPreferences.fromJson(data['data'] as Map<String, dynamic>);
      }
      return DeliveryPreferences.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateDeliveryPreferences(String retailerId, Map<String, dynamic> data) async {
    try {
      await _client.patch('$_base/$retailerId/delivery-preferences', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CollectionPreferences> getCollectionPreferences(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId/collection-preferences');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return CollectionPreferences.fromJson(data['data'] as Map<String, dynamic>);
      }
      return CollectionPreferences.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateCollectionPreferences(String retailerId, Map<String, dynamic> data) async {
    try {
      await _client.patch('$_base/$retailerId/collection-preferences', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CreditProfile> getCreditProfile(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId/credit-profile');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return CreditProfile.fromJson(data['data'] as Map<String, dynamic>);
      }
      return CreditProfile.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<OutstandingSummary> getOutstanding(String retailerId) async {
    try {
      final response = await _client.get('$_base/$retailerId/outstanding');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return OutstandingSummary.fromJson(data['data'] as Map<String, dynamic>);
      }
      return OutstandingSummary.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<BusinessCategory>> getBusinessCategories() async {
    try {
      final response = await _client.get('/api/v1/business-categories');
      final data = response.data;
      final list = (data is Map && data['data'] is List) ? data['data'] as List : data as List;
      return list.map((e) => BusinessCategory.fromJson(e as Map<String, dynamic>)).toList();
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

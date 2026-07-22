import 'package:dio/dio.dart';
import 'package:dairy_frontend/core/constants/api_constants.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/staff_management/models/staff_model.dart';
import 'package:dairy_frontend/features/staff_management/models/role_model.dart';
import 'package:dairy_frontend/features/staff_management/models/permission_model.dart';

class StaffService {
  final ApiClient _apiClient;

  StaffService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<StaffModel> inviteStaff({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? roleId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.users,
        data: {
          'email': email,
          if (firstName != null && firstName.isNotEmpty) 'first_name': firstName,
          if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (roleId != null) 'role_id': roleId,
        },
      );
      return StaffModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<StaffModel>> getStaff({String? query, String? status}) async {
    try {
      final params = <String, dynamic>{};
      if (query != null && query.isNotEmpty) params['q'] = query;
      if (status != null) params['status'] = status;
      final response = await _apiClient.get(
        ApiConstants.users,
        queryParameters: params.isNotEmpty ? params : null,
      );
      final data = response.data;
      if (data is List) {
        return data.map((e) => StaffModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => StaffModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<StaffModel> getStaffDetail(String id) async {
    try {
      final response = await _apiClient.get(ApiConstants.user(id));
      return StaffModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<StaffModel> updateStaff(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.patch(ApiConstants.user(id), data: data);
      return StaffModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deactivateStaff(String id) async {
    try {
      await _apiClient.post(ApiConstants.userDeactivate(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> activateStaff(String id) async {
    try {
      await _apiClient.post(ApiConstants.userActivate(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RoleModel>> getRoles() async {
    try {
      final response = await _apiClient.get(ApiConstants.roles);
      final data = response.data;
      if (data is List) {
        return data.map((e) => RoleModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RoleModel> getRoleDetail(String id) async {
    try {
      final response = await _apiClient.get(ApiConstants.role(id));
      return RoleModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RoleModel> createRole(String name, String description) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.roles,
        data: {'name': name, 'description': description},
      );
      return RoleModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> assignRole(String userId, String roleId) async {
    try {
      await _apiClient.post(
        ApiConstants.userRoles(userId),
        data: {'role_id': roleId},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeRole(String userId, String roleId) async {
    try {
      await _apiClient.delete(ApiConstants.userRole(userId, roleId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PermissionModel>> getPermissions({String? roleId}) async {
    try {
      final path = roleId != null ? ApiConstants.rolePermissions(roleId) : ApiConstants.permissions;
      final response = await _apiClient.get(path);
      final data = response.data;
      if (data is List) {
        return data.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.error is ApiException) return e.error as ApiException;
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
        default:
          return ApiException(message: message, statusCode: statusCode);
      }
    }
    return ApiException(message: e.message ?? 'Unable to reach the server. Please check your connection and try again.');
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['detail'] != null) return data['detail'].toString();
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    return 'Unable to reach the server. Please check your connection and try again.';
  }
}

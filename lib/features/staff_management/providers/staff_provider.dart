import 'package:flutter/foundation.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/staff_management/services/staff_service.dart';
import 'package:dairy_frontend/features/staff_management/models/staff_model.dart';
import 'package:dairy_frontend/features/staff_management/models/role_model.dart';

class StaffProvider extends ChangeNotifier {
  final StaffService _staffService;

  StaffProvider({required StaffService staffService}) : _staffService = staffService;

  List<StaffModel> _staffList = [];
  List<RoleModel> _roleList = [];
  StaffModel? _selectedStaff;
  bool _isLoading = false;
  String? _error;

  List<StaffModel> get staffList => _staffList;
  List<RoleModel> get roleList => _roleList;
  StaffModel? get selectedStaff => _selectedStaff;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalStaff => _staffList.length;
  int get activeStaff => _staffList.where((s) => s.status == 'active').length;
  int get inactiveStaff => _staffList.where((s) => s.status == 'inactive').length;
  int get pendingInvitations => _staffList.where((s) => s.status == 'pending').length;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? v) {
    _error = v;
    notifyListeners();
  }

  Future<void> loadStaff() async {
    _setLoading(true);
    _setError(null);
    try {
      _staffList = await _staffService.getStaff();
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('Unable to load staff');
      _setLoading(false);
    }
  }

  Future<List<StaffModel>> searchStaff(String query) async {
    try {
      return await _staffService.getStaff(query: query);
    } on ApiException catch (e) {
      _setError(e.message);
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> loadRoles() async {
    _setLoading(true);
    _setError(null);
    try {
      _roleList = await _staffService.getRoles();
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (_) {
      _setError('Unable to load roles');
      _setLoading(false);
    }
  }

  Future<String?> inviteStaff({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? roleId,
  }) async {
    _setError(null);
    try {
      final staff = await _staffService.inviteStaff(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        roleId: roleId,
      );
      _staffList.insert(0, staff);
      notifyListeners();
      return null;
    } on DuplicateException {
      return 'This email is already registered';
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Unable to send invitation';
    }
  }

  Future<String?> createRole(String name, String description) async {
    _setError(null);
    try {
      final role = await _staffService.createRole(name, description);
      _roleList.add(role);
      notifyListeners();
      return null;
    } on DuplicateException {
      return 'A role with this name already exists';
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Unable to create role';
    }
  }

  Future<String?> assignRole(String userId, String roleId) async {
    try {
      await _staffService.assignRole(userId, roleId);
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Unable to assign role';
    }
  }

  Future<String?> removeRole(String userId, String roleId) async {
    try {
      await _staffService.removeRole(userId, roleId);
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Unable to remove role';
    }
  }
}

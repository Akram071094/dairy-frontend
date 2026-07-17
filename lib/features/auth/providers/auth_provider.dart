import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/auth/models/auth_models.dart';
import 'package:dairy_frontend/features/auth/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FlutterSecureStorage _storage;

  UserModel? _currentUser;
  String? _accessToken;
  bool _isLoading = false;
  String? _error;
  String? _organizationId;

  AuthProvider({
    required AuthService authService,
    FlutterSecureStorage? storage,
  })  : _authService = authService,
        _storage = storage ?? const FlutterSecureStorage();

  UserModel? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get organizationId => _organizationId;
  bool get isAuthenticated => _accessToken != null && _currentUser != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> signup(SignupRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authService.signup(request);
      await _storeTokens(response.accessToken, response.refreshToken);
      _accessToken = response.accessToken;
      _currentUser = response.user;
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  Future<void> login(LoginRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authService.login(request);
      await _storeTokens(response.accessToken, response.refreshToken);
      _accessToken = response.accessToken;
      _currentUser = response.user;
      if (response.organization != null) {
        _organizationId = response.organization!.id;
        await _storage.write(
          key: AppConstants.currentOrgIdKey,
          value: _organizationId,
        );
      }
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  Future<void> checkAuth() async {
    _setLoading(true);
    _setError(null);
    try {
      final token = await _storage.read(key: AppConstants.accessTokenKey);
      if (token == null || token.isEmpty) {
        _accessToken = null;
        _currentUser = null;
        _setLoading(false);
        return;
      }
      _accessToken = token;
      final user = await _authService.getMe();
      _currentUser = user;
      _organizationId = await _storage.read(key: AppConstants.currentOrgIdKey);
      _setLoading(false);
    } on DioException catch (_) {
      await _clearAuth();
      _setLoading(false);
    } on ApiException catch (_) {
      await _clearAuth();
      _setLoading(false);
    } catch (e) {
      await _clearAuth();
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
    } catch (_) {}
    await _clearAuth();
    _setLoading(false);
  }

  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
  }

  Future<void> _clearAuth() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.currentOrgIdKey);
    _accessToken = null;
    _currentUser = null;
    _organizationId = null;
    _error = null;
    notifyListeners();
  }
}

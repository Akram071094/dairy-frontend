import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/features/onboarding/models/organization_model.dart';
import 'package:dairy_frontend/features/onboarding/models/onboarding_status.dart';
import 'package:dairy_frontend/features/onboarding/services/onboarding_service.dart';

class OnboardingProvider extends ChangeNotifier {
  final OnboardingService _service;

  OnboardingStatus? _status;
  OrganizationModel? _organization;
  bool _isLoading = false;
  String? _error;

  OnboardingProvider(ApiClient apiClient) : _service = OnboardingService(apiClient);

  OnboardingStatus? get status => _status;
  OrganizationModel? get organization => _organization;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  Future<void> loadStatus(String orgId) async {
    _setLoading(true);
    _setError(null);
    try {
      _status = await _service.getOnboardingStatus(orgId);
      _organization = await _service.getOrganization(orgId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<String> createOrg(OrganizationCreateRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      final org = await _service.createOrganization(request);
      _organization = org;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.currentOrgIdKey, org.id);
      return org.id;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveProfile(String orgId, BusinessProfileRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.createBusinessProfile(orgId, request);
      await loadStatus(orgId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveBranding(String orgId, BrandingRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.createBranding(orgId, request);
      await loadStatus(orgId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> savePreferences(String orgId, PreferencesRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.createPreferences(orgId, request);
      await loadStatus(orgId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> activateOrg(String orgId) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.activateOrganization(orgId);
      _status = await _service.getOnboardingStatus(orgId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}

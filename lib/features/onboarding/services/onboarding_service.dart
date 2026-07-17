import 'package:dairy_frontend/core/constants/api_constants.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/features/onboarding/models/organization_model.dart';
import 'package:dairy_frontend/features/onboarding/models/onboarding_status.dart';

class OnboardingService {
  final ApiClient _apiClient;

  OnboardingService(this._apiClient);

  Future<OrganizationModel> createOrganization(OrganizationCreateRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.organizations,
      data: request.toJson(),
    );
    return OrganizationModel.fromJson(response.data);
  }

  Future<OrganizationModel> getOrganization(String orgId) async {
    final response = await _apiClient.get(
      ApiConstants.organization(orgId),
    );
    return OrganizationModel.fromJson(response.data);
  }

  Future<BusinessProfileModel> createBusinessProfile(
    String orgId,
    BusinessProfileRequest request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.orgProfile(orgId),
      data: request.toJson(),
    );
    return BusinessProfileModel.fromJson(response.data);
  }

  Future<BrandingModel> createBranding(
    String orgId,
    BrandingRequest request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.orgBranding(orgId),
      data: request.toJson(),
    );
    return BrandingModel.fromJson(response.data);
  }

  Future<PreferencesModel> createPreferences(
    String orgId,
    PreferencesRequest request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.orgPreferences(orgId),
      data: request.toJson(),
    );
    return PreferencesModel.fromJson(response.data);
  }

  Future<Map<String, dynamic>> activateOrganization(String orgId) async {
    final response = await _apiClient.post(
      ApiConstants.orgActivate(orgId),
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
  }

  Future<OnboardingStatus> getOnboardingStatus(String orgId) async {
    final response = await _apiClient.get(
      ApiConstants.orgOnboardingStatus(orgId),
    );
    return OnboardingStatus.fromJson(response.data);
  }
}

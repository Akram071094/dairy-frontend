class OnboardingStatus {
  final String organizationId;
  final OnboardingSteps steps;
  final String currentStep;
  final bool isComplete;

  OnboardingStatus({
    required this.organizationId,
    required this.steps,
    required this.currentStep,
    required this.isComplete,
  });

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) {
    return OnboardingStatus(
      organizationId: json['organization_id']?.toString() ?? '',
      steps: OnboardingSteps.fromJson(json['steps'] ?? {}),
      currentStep: json['current_step'] ?? 'create_organization',
      isComplete: json['is_complete'] ?? false,
    );
  }

  int get completedCount => [
    steps.createOrganization,
    steps.businessProfile,
    steps.branding,
    steps.preferences,
    steps.activation,
  ].where((s) => s).length;

  int get totalSteps => 5;
  double get progress => completedCount / totalSteps;
  String get nextActionLabel {
    if (isComplete) return 'Onboarding Complete';
    if (!steps.createOrganization) return 'Register Business';
    if (!steps.businessProfile) return 'Add Business Profile';
    if (!steps.branding) return 'Set Up Branding';
    if (!steps.preferences) return 'Configure Preferences';
    if (!steps.activation) return 'Review & Activate';
    return 'All Done!';
  }
}

class OnboardingSteps {
  final bool createOrganization;
  final bool businessProfile;
  final bool branding;
  final bool preferences;
  final bool activation;

  OnboardingSteps({
    required this.createOrganization,
    required this.businessProfile,
    required this.branding,
    required this.preferences,
    required this.activation,
  });

  factory OnboardingSteps.fromJson(Map<String, dynamic> json) {
    return OnboardingSteps(
      createOrganization: json['create_organization'] ?? false,
      businessProfile: json['business_profile'] ?? false,
      branding: json['branding'] ?? false,
      preferences: json['preferences'] ?? false,
      activation: json['activation'] ?? false,
    );
  }
}

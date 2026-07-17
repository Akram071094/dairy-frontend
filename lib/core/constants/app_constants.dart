class AppConstants {
  static const String appName = 'Zheng';
  static const String appVersion = '1.0.0';
  static const String aiAssistantName = 'Mia';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String onboardingProgressKey = 'onboarding_progress';
  static const String currentOrgIdKey = 'current_org_id';
  static const String onboardingSkippedKey = 'onboarding_skipped';

  // Timeouts
  static const int connectTimeout = 60000;
  static const int receiveTimeout = 60000;
  static const int uploadTimeout = 120000;

  // Limits
  static const int maxFileSize = 5 * 1024 * 1024;
  static const int maxBusinessCodeLength = 50;
  static const int minBusinessCodeLength = 3;
  static const int maxDisplayNameLength = 255;
  static const int minPasswordLength = 8;
}

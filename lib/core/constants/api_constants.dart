class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const String apiPrefix = '/api/v1';

  // Auth
  static const String signup = '$apiPrefix/auth/signup';
  static const String login = '$apiPrefix/auth/login';
  static const String logout = '$apiPrefix/auth/logout';
  static const String refresh = '$apiPrefix/auth/refresh';
  static const String me = '$apiPrefix/auth/me';
  static const String changePassword = '$apiPrefix/auth/me/change-password';

  // Organization
  static const String organizations = '$apiPrefix/organizations';
  static String organization(String id) => '$organizations/$id';
  static String orgProfile(String orgId) => '$organizations/$orgId/profile';
  static String orgBranding(String orgId) => '$organizations/$orgId/branding';
  static String orgPreferences(String orgId) => '$organizations/$orgId/preferences';
  static String orgActivate(String orgId) => '$organizations/$orgId/activate';
  static String orgOnboardingStatus(String orgId) => '$organizations/$orgId/onboarding-status';
  static String orgRestore(String orgId) => '$organizations/$orgId/restore';
  static String orgSuspend(String orgId) => '$organizations/$orgId/suspend';

  // Users
  static const String users = '$apiPrefix/users';
  static String user(String id) => '$users/$id';
  static String userActivate(String id) => '$users/$id/activate';
  static String userDeactivate(String id) => '$users/$id/deactivate';
  static String userSuspend(String id) => '$users/$id/suspend';
  static String userRoles(String userId) => '$users/$userId/roles';
  static String userRole(String userId, String roleId) => '$users/$userId/roles/$roleId';

  // Roles & Permissions
  static const String roles = '$apiPrefix/roles';
  static String role(String id) => '$roles/$id';
  static String rolePermissions(String roleId) => '$roles/$roleId/permissions';
  static String rolePermission(String roleId, String permId) =>
      '$roles/$roleId/permissions/$permId';
  static const String permissions = '$apiPrefix/permissions';

  // Sessions
  static const String sessions = '$apiPrefix/sessions';
  static String session(String id) => '$sessions/$id';
  static const String mySessions = '$apiPrefix/me/sessions';
  static String mySession(String id) => '$mySessions/$id';

  // Resolve
  static const String resolve = '$apiPrefix/resolve';
  static String resolveIdentityByEmail(String email) => '$resolve/identity/$email';
  static String resolveIdentityByUserId(String userId) => '$resolve/identity/$userId';
  static String resolveRoles(String userId) => '$resolve/roles/$userId';
  static String resolvePermissions(String roleId) => '$resolve/permissions/$roleId';
  static const String resolveAuthorization = '$resolve/authorization';
  static const String resolveAuthorizationBatch = '$resolve/authorization/batch';
}

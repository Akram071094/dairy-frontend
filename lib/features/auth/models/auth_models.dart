import 'package:uuid/uuid.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatarUrl;
  final String status;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.phone,
    this.avatarUrl,
    this.status = 'active',
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? const Uuid().v4(),
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      status: json['status'] ?? 'active',
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
    'avatar_url': avatarUrl,
    'status': status,
  };
}

class LoginRequest {
  final String email;
  final String password;
  final String? organizationCode;

  LoginRequest({required this.email, required this.password, this.organizationCode});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    if (organizationCode != null) 'organization_code': organizationCode,
  };
}

class SignupRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignupRequest({
    required this.email,
    required this.password,
    required this.firstName,
    this.lastName = '',
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'first_name': firstName,
    'last_name': lastName,
  };
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;
  final OrganizationBrief? organization;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
    this.organization,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 3600,
      user: UserModel.fromJson(json['user'] ?? {}),
      organization: json['organization'] != null
          ? OrganizationBrief.fromJson(json['organization'])
          : null,
    );
  }
}

class SignupResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;
  final OrganizationBrief? organization;

  SignupResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
    this.organization,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 3600,
      user: UserModel.fromJson(json['user'] ?? {}),
      organization: json['organization'] != null
          ? OrganizationBrief.fromJson(json['organization'])
          : null,
    );
  }
}

class OrganizationBrief {
  final String id;
  final String businessCode;
  final String displayName;
  final String status;

  OrganizationBrief({
    required this.id,
    required this.businessCode,
    required this.displayName,
    required this.status,
  });

  factory OrganizationBrief.fromJson(Map<String, dynamic> json) {
    return OrganizationBrief(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? '',
      displayName: json['display_name'] ?? json['org_name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

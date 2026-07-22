import 'package:uuid/uuid.dart';

class StaffModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatarUrl;
  final String status;
  final String? role;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;

  StaffModel({
    required this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.phone,
    this.avatarUrl,
    this.status = 'active',
    this.role,
    this.lastLoginAt,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return '$f$l'.isNotEmpty ? '$f$l'.toUpperCase() : email[0].toUpperCase();
  }

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id']?.toString() ?? const Uuid().v4(),
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      status: json['status'] ?? 'active',
      role: json['role'],
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
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
    'role': role,
  };
}

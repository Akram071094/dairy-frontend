import 'package:uuid/uuid.dart';

class RoleModel {
  final String id;
  final String name;
  final String description;
  final int userCount;
  final int permissionCount;
  final DateTime? createdAt;

  RoleModel({
    required this.id,
    required this.name,
    this.description = '',
    this.userCount = 0,
    this.permissionCount = 0,
    this.createdAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? const Uuid().v4(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      userCount: json['user_count'] ?? 0,
      permissionCount: json['permission_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
  };
}

class RoleAssignmentRequest {
  final String roleId;

  RoleAssignmentRequest({required this.roleId});

  Map<String, dynamic> toJson() => {
    'role_id': roleId,
  };
}

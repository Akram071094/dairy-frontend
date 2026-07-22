import 'package:uuid/uuid.dart';

class PermissionModel {
  final String id;
  final String name;
  final String description;
  final String group;
  final bool isAssigned;

  PermissionModel({
    required this.id,
    required this.name,
    this.description = '',
    this.group = '',
    this.isAssigned = false,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id']?.toString() ?? const Uuid().v4(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      group: json['group'] ?? '',
      isAssigned: json['is_assigned'] ?? false,
    );
  }
}

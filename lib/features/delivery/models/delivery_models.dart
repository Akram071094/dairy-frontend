enum AssignmentStatus {
  assigned,
  accepted,
  inProgress,
  completed,
  rejected,
  cancelled
}

extension AssignmentStatusExtension on AssignmentStatus {
  String get value {
    switch (this) {
      case AssignmentStatus.assigned:
        return 'assigned';
      case AssignmentStatus.accepted:
        return 'accepted';
      case AssignmentStatus.inProgress:
        return 'in_progress';
      case AssignmentStatus.completed:
        return 'completed';
      case AssignmentStatus.rejected:
        return 'rejected';
      case AssignmentStatus.cancelled:
        return 'cancelled';
    }
  }

  static AssignmentStatus fromString(String value) {
    switch (value) {
      case 'assigned':
        return AssignmentStatus.assigned;
      case 'accepted':
        return AssignmentStatus.accepted;
      case 'in_progress':
        return AssignmentStatus.inProgress;
      case 'completed':
        return AssignmentStatus.completed;
      case 'rejected':
        return AssignmentStatus.rejected;
      case 'cancelled':
        return AssignmentStatus.cancelled;
      default:
        return AssignmentStatus.assigned;
    }
  }
}

enum ActionType {
  created,
  assigned,
  accepted,
  rejected,
  cancelled,
  started,
  completed
}

extension ActionTypeExtension on ActionType {
  String get value {
    switch (this) {
      case ActionType.created:
        return 'created';
      case ActionType.assigned:
        return 'assigned';
      case ActionType.accepted:
        return 'accepted';
      case ActionType.rejected:
        return 'rejected';
      case ActionType.cancelled:
        return 'cancelled';
      case ActionType.started:
        return 'started';
      case ActionType.completed:
        return 'completed';
    }
  }

  static ActionType fromString(String value) {
    switch (value) {
      case 'created':
        return ActionType.created;
      case 'assigned':
        return ActionType.assigned;
      case 'accepted':
        return ActionType.accepted;
      case 'rejected':
        return ActionType.rejected;
      case 'cancelled':
        return ActionType.cancelled;
      case 'started':
        return ActionType.started;
      case 'completed':
        return ActionType.completed;
      default:
        return ActionType.created;
    }
  }
}

class ManifestAssignment {
  final String id;
  final String manifestId;
  final DateTime? manifestDate;
  final String assignedStaffId;
  final String assignedStaffName;
  final AssignmentStatus assignmentStatus;
  final String deliverySession;
  final DateTime? assignedAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? notes;
  final int version;

  ManifestAssignment({
    required this.id,
    required this.manifestId,
    this.manifestDate,
    required this.assignedStaffId,
    this.assignedStaffName = '',
    this.assignmentStatus = AssignmentStatus.assigned,
    this.deliverySession = 'morning',
    this.assignedAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.notes,
    this.version = 1,
  });

  factory ManifestAssignment.fromJson(Map<String, dynamic> json) {
    return ManifestAssignment(
      id: json['id']?.toString() ?? '',
      manifestId: json['manifest_id']?.toString() ?? '',
      manifestDate: json['manifest_date'] != null
          ? DateTime.parse(json['manifest_date'])
          : null,
      assignedStaffId: json['assigned_staff_id']?.toString() ?? '',
      assignedStaffName: json['assigned_staff_name'] ?? '',
      assignmentStatus: json['assignment_status'] != null
          ? AssignmentStatusExtension.fromString(json['assignment_status'])
          : AssignmentStatus.assigned,
      deliverySession: json['delivery_session'] ?? 'morning',
      assignedAt: json['assigned_at'] != null
          ? DateTime.parse(json['assigned_at'])
          : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      notes: json['notes'],
      version: json['version'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'manifest_id': manifestId,
    if (manifestDate != null) 'manifest_date': manifestDate!.toIso8601String(),
    'assigned_staff_id': assignedStaffId,
    'assigned_staff_name': assignedStaffName,
    'assignment_status': assignmentStatus.value,
    'delivery_session': deliverySession,
    if (assignedAt != null) 'assigned_at': assignedAt!.toIso8601String(),
    if (acceptedAt != null) 'accepted_at': acceptedAt!.toIso8601String(),
    if (startedAt != null) 'started_at': startedAt!.toIso8601String(),
    if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    if (notes != null) 'notes': notes,
    'version': version,
  };
}

class AssignmentHistory {
  final String id;
  final String assignmentId;
  final String manifestId;
  final DateTime? manifestDate;
  final String assignedStaffId;
  final String assignedStaffName;
  final AssignmentStatus assignmentStatus;
  final String deliverySession;
  final ActionType actionType;
  final String actionBy;
  final DateTime? actionAt;

  AssignmentHistory({
    required this.id,
    required this.assignmentId,
    required this.manifestId,
    this.manifestDate,
    required this.assignedStaffId,
    this.assignedStaffName = '',
    required this.assignmentStatus,
    this.deliverySession = 'morning',
    required this.actionType,
    this.actionBy = '',
    this.actionAt,
  });

  factory AssignmentHistory.fromJson(Map<String, dynamic> json) {
    return AssignmentHistory(
      id: json['id']?.toString() ?? '',
      assignmentId: json['assignment_id']?.toString() ?? '',
      manifestId: json['manifest_id']?.toString() ?? '',
      manifestDate: json['manifest_date'] != null
          ? DateTime.parse(json['manifest_date'])
          : null,
      assignedStaffId: json['assigned_staff_id']?.toString() ?? '',
      assignedStaffName: json['assigned_staff_name'] ?? '',
      assignmentStatus: json['assignment_status'] != null
          ? AssignmentStatusExtension.fromString(json['assignment_status'])
          : AssignmentStatus.assigned,
      deliverySession: json['delivery_session'] ?? 'morning',
      actionType: json['action_type'] != null
          ? ActionTypeExtension.fromString(json['action_type'])
          : ActionType.created,
      actionBy: json['action_by'] ?? '',
      actionAt: json['action_at'] != null
          ? DateTime.parse(json['action_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'assignment_id': assignmentId,
    'manifest_id': manifestId,
    if (manifestDate != null) 'manifest_date': manifestDate!.toIso8601String(),
    'assigned_staff_id': assignedStaffId,
    'assigned_staff_name': assignedStaffName,
    'assignment_status': assignmentStatus.value,
    'delivery_session': deliverySession,
    'action_type': actionType.value,
    'action_by': actionBy,
    if (actionAt != null) 'action_at': actionAt!.toIso8601String(),
  };
}

class AssignmentActivity {
  final String id;
  final String activityType;
  final String activityBy;
  final String activityName;
  final DateTime? activityAt;
  final String? activityDescription;
  final String? previousValue;
  final String? newValue;

  AssignmentActivity({
    required this.id,
    required this.activityType,
    required this.activityBy,
    this.activityName = '',
    this.activityAt,
    this.activityDescription,
    this.previousValue,
    this.newValue,
  });

  factory AssignmentActivity.fromJson(Map<String, dynamic> json) {
    return AssignmentActivity(
      id: json['id']?.toString() ?? '',
      activityType: json['activity_type'] ?? '',
      activityBy: json['activity_by'] ?? '',
      activityName: json['activity_name'] ?? '',
      activityAt: json['activity_at'] != null
          ? DateTime.parse(json['activity_at'])
          : null,
      activityDescription: json['activity_description'],
      previousValue: json['previous_value'],
      newValue: json['new_value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'activity_type': activityType,
    'activity_by': activityBy,
    'activity_name': activityName,
    if (activityAt != null) 'activity_at': activityAt!.toIso8601String(),
    if (activityDescription != null) 'activity_description': activityDescription,
    if (previousValue != null) 'previous_value': previousValue,
    if (newValue != null) 'new_value': newValue,
  };
}

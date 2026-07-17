enum PlanningStatus { generated, reviewed, approved, cancelled }

extension PlanningStatusExtension on PlanningStatus {
  String get value {
    switch (this) {
      case PlanningStatus.generated:
        return 'generated';
      case PlanningStatus.reviewed:
        return 'reviewed';
      case PlanningStatus.approved:
        return 'approved';
      case PlanningStatus.cancelled:
        return 'cancelled';
    }
  }

  static PlanningStatus fromString(String value) {
    switch (value) {
      case 'generated':
        return PlanningStatus.generated;
      case 'reviewed':
        return PlanningStatus.reviewed;
      case 'approved':
        return PlanningStatus.approved;
      case 'cancelled':
        return PlanningStatus.cancelled;
      default:
        return PlanningStatus.generated;
    }
  }
}

enum ManifestItemStatus { pending, approved, modified }

extension ManifestItemStatusExtension on ManifestItemStatus {
  String get value {
    switch (this) {
      case ManifestItemStatus.pending:
        return 'pending';
      case ManifestItemStatus.approved:
        return 'approved';
      case ManifestItemStatus.modified:
        return 'modified';
    }
  }

  static ManifestItemStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return ManifestItemStatus.pending;
      case 'approved':
        return ManifestItemStatus.approved;
      case 'modified':
        return ManifestItemStatus.modified;
      default:
        return ManifestItemStatus.pending;
    }
  }
}

enum ExceptionSeverity { warning, error }

extension ExceptionSeverityExtension on ExceptionSeverity {
  String get value {
    switch (this) {
      case ExceptionSeverity.warning:
        return 'warning';
      case ExceptionSeverity.error:
        return 'error';
    }
  }

  static ExceptionSeverity fromString(String value) {
    switch (value) {
      case 'warning':
        return ExceptionSeverity.warning;
      case 'error':
        return ExceptionSeverity.error;
      default:
        return ExceptionSeverity.warning;
    }
  }
}

enum PlanningSession { morning, evening }

extension PlanningSessionExtension on PlanningSession {
  String get value {
    switch (this) {
      case PlanningSession.morning:
        return 'morning';
      case PlanningSession.evening:
        return 'evening';
    }
  }

  static PlanningSession fromString(String value) {
    switch (value) {
      case 'morning':
        return PlanningSession.morning;
      case 'evening':
        return PlanningSession.evening;
      default:
        return PlanningSession.morning;
    }
  }
}

class PlanningBatch {
  final String id;
  final String organizationId;
  final DateTime? planningDate;
  final PlanningSession planningSession;
  final PlanningStatus status;
  final int totalRetailers;
  final int totalItems;
  final int totalExceptions;
  final String? notes;
  final DateTime? generatedAt;
  final DateTime? reviewedAt;
  final DateTime? approvedAt;

  PlanningBatch({
    required this.id,
    required this.organizationId,
    this.planningDate,
    this.planningSession = PlanningSession.morning,
    this.status = PlanningStatus.generated,
    this.totalRetailers = 0,
    this.totalItems = 0,
    this.totalExceptions = 0,
    this.notes,
    this.generatedAt,
    this.reviewedAt,
    this.approvedAt,
  });

  factory PlanningBatch.fromJson(Map<String, dynamic> json) {
    return PlanningBatch(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      planningDate: json['planning_date'] != null
          ? DateTime.parse(json['planning_date'])
          : null,
      planningSession: json['planning_session'] != null
          ? PlanningSessionExtension.fromString(json['planning_session'])
          : PlanningSession.morning,
      status: json['status'] != null
          ? PlanningStatusExtension.fromString(json['status'])
          : PlanningStatus.generated,
      totalRetailers: json['total_retailers'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      totalExceptions: json['total_exceptions'] ?? 0,
      notes: json['notes'],
      generatedAt: json['generated_at'] != null
          ? DateTime.parse(json['generated_at'])
          : null,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': organizationId,
    if (planningDate != null) 'planning_date': planningDate!.toIso8601String(),
    'planning_session': planningSession.value,
    'status': status.value,
    'total_retailers': totalRetailers,
    'total_items': totalItems,
    'total_exceptions': totalExceptions,
    if (notes != null) 'notes': notes,
    if (generatedAt != null) 'generated_at': generatedAt!.toIso8601String(),
    if (reviewedAt != null) 'reviewed_at': reviewedAt!.toIso8601String(),
    if (approvedAt != null) 'approved_at': approvedAt!.toIso8601String(),
  };
}

class ManifestItem {
  final String id;
  final String retailerId;
  final String retailerName;
  final String deliverySession;
  final String skuId;
  final String skuName;
  final double quantity;
  final String unit;
  final String supplyModel;
  final String source;
  final ManifestItemStatus status;
  final int sortOrder;

  ManifestItem({
    required this.id,
    required this.retailerId,
    required this.retailerName,
    required this.deliverySession,
    required this.skuId,
    required this.skuName,
    this.quantity = 0,
    this.unit = '',
    this.supplyModel = '',
    this.source = '',
    this.status = ManifestItemStatus.pending,
    this.sortOrder = 0,
  });

  factory ManifestItem.fromJson(Map<String, dynamic> json) {
    return ManifestItem(
      id: json['id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      retailerName: json['retailer_name'] ?? '',
      deliverySession: json['delivery_session'] ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      skuName: json['sku_name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      supplyModel: json['supply_model'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] != null
          ? ManifestItemStatusExtension.fromString(json['status'])
          : ManifestItemStatus.pending,
      sortOrder: json['sort_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'retailer_id': retailerId,
    'retailer_name': retailerName,
    'delivery_session': deliverySession,
    'sku_id': skuId,
    'sku_name': skuName,
    'quantity': quantity,
    'unit': unit,
    'supply_model': supplyModel,
    'source': source,
    'status': status.value,
    'sort_order': sortOrder,
  };
}

class DeliveryManifest {
  final String id;
  final String planningBatchId;
  final DateTime? manifestDate;
  final String status;
  final int totalRetailers;
  final int totalItems;
  final double totalQuantity;
  final List<ManifestItem> items;

  DeliveryManifest({
    required this.id,
    required this.planningBatchId,
    this.manifestDate,
    this.status = 'generated',
    this.totalRetailers = 0,
    this.totalItems = 0,
    this.totalQuantity = 0,
    this.items = const [],
  });

  factory DeliveryManifest.fromJson(Map<String, dynamic> json) {
    return DeliveryManifest(
      id: json['id']?.toString() ?? '',
      planningBatchId: json['planning_batch_id']?.toString() ?? '',
      manifestDate: json['manifest_date'] != null
          ? DateTime.parse(json['manifest_date'])
          : null,
      status: json['status'] ?? 'generated',
      totalRetailers: json['total_retailers'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      totalQuantity: (json['total_quantity'] ?? 0).toDouble(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => ManifestItem.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'planning_batch_id': planningBatchId,
    if (manifestDate != null) 'manifest_date': manifestDate!.toIso8601String(),
    'status': status,
    'total_retailers': totalRetailers,
    'total_items': totalItems,
    'total_quantity': totalQuantity,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class PlanningSummary {
  final DateTime? summaryDate;
  final int totalRetailers;
  final int totalItems;
  final double totalQuantity;
  final int standingOrderRetailers;
  final int dailyOrderRetailers;
  final int morningItems;
  final int eveningItems;
  final int totalExceptions;

  PlanningSummary({
    this.summaryDate,
    this.totalRetailers = 0,
    this.totalItems = 0,
    this.totalQuantity = 0,
    this.standingOrderRetailers = 0,
    this.dailyOrderRetailers = 0,
    this.morningItems = 0,
    this.eveningItems = 0,
    this.totalExceptions = 0,
  });

  factory PlanningSummary.fromJson(Map<String, dynamic> json) {
    return PlanningSummary(
      summaryDate: json['summary_date'] != null
          ? DateTime.parse(json['summary_date'])
          : null,
      totalRetailers: json['total_retailers'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      totalQuantity: (json['total_quantity'] ?? 0).toDouble(),
      standingOrderRetailers: json['standing_order_retailers'] ?? 0,
      dailyOrderRetailers: json['daily_order_retailers'] ?? 0,
      morningItems: json['morning_items'] ?? 0,
      eveningItems: json['evening_items'] ?? 0,
      totalExceptions: json['total_exceptions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    if (summaryDate != null) 'summary_date': summaryDate!.toIso8601String(),
    'total_retailers': totalRetailers,
    'total_items': totalItems,
    'total_quantity': totalQuantity,
    'standing_order_retailers': standingOrderRetailers,
    'daily_order_retailers': dailyOrderRetailers,
    'morning_items': morningItems,
    'evening_items': eveningItems,
    'total_exceptions': totalExceptions,
  };
}

class PlanningException {
  final String id;
  final String exceptionType;
  final ExceptionSeverity severity;
  final String entityType;
  final String entityId;
  final String retailerId;
  final String exceptionMessage;
  final String status;
  final String? resolutionNotes;

  PlanningException({
    required this.id,
    required this.exceptionType,
    this.severity = ExceptionSeverity.warning,
    required this.entityType,
    required this.entityId,
    required this.retailerId,
    required this.exceptionMessage,
    this.status = 'open',
    this.resolutionNotes,
  });

  factory PlanningException.fromJson(Map<String, dynamic> json) {
    return PlanningException(
      id: json['id']?.toString() ?? '',
      exceptionType: json['exception_type'] ?? '',
      severity: json['severity'] != null
          ? ExceptionSeverityExtension.fromString(json['severity'])
          : ExceptionSeverity.warning,
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      exceptionMessage: json['exception_message'] ?? '',
      status: json['status'] ?? 'open',
      resolutionNotes: json['resolution_notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exception_type': exceptionType,
    'severity': severity.value,
    'entity_type': entityType,
    'entity_id': entityId,
    'retailer_id': retailerId,
    'exception_message': exceptionMessage,
    'status': status,
    if (resolutionNotes != null) 'resolution_notes': resolutionNotes,
  };
}

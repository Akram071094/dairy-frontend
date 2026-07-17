import 'package:dairy_frontend/features/retailers/models/retailer_models.dart';

enum SupplyModel { standingOrder, dailyOrder, routeSales, hybrid }

extension SupplyModelExtension on SupplyModel {
  String get value {
    switch (this) {
      case SupplyModel.standingOrder:
        return 'standing_order';
      case SupplyModel.dailyOrder:
        return 'daily_order';
      case SupplyModel.routeSales:
        return 'route_sales';
      case SupplyModel.hybrid:
        return 'hybrid';
    }
  }

  static SupplyModel fromString(String value) {
    switch (value) {
      case 'standing_order':
        return SupplyModel.standingOrder;
      case 'daily_order':
        return SupplyModel.dailyOrder;
      case 'route_sales':
        return SupplyModel.routeSales;
      case 'hybrid':
        return SupplyModel.hybrid;
      default:
        return SupplyModel.standingOrder;
    }
  }
}

enum StandingOrderStatus { active, suspended, inactive }

extension StandingOrderStatusExtension on StandingOrderStatus {
  String get value {
    switch (this) {
      case StandingOrderStatus.active:
        return 'active';
      case StandingOrderStatus.suspended:
        return 'suspended';
      case StandingOrderStatus.inactive:
        return 'inactive';
    }
  }

  static StandingOrderStatus fromString(String value) {
    switch (value) {
      case 'active':
        return StandingOrderStatus.active;
      case 'suspended':
        return StandingOrderStatus.suspended;
      case 'inactive':
        return StandingOrderStatus.inactive;
      default:
        return StandingOrderStatus.active;
    }
  }
}

enum DailyOrderStatus { draft, confirmed, cancelled }

extension DailyOrderStatusExtension on DailyOrderStatus {
  String get value {
    switch (this) {
      case DailyOrderStatus.draft:
        return 'draft';
      case DailyOrderStatus.confirmed:
        return 'confirmed';
      case DailyOrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static DailyOrderStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return DailyOrderStatus.draft;
      case 'confirmed':
        return DailyOrderStatus.confirmed;
      case 'cancelled':
        return DailyOrderStatus.cancelled;
      default:
        return DailyOrderStatus.draft;
    }
  }
}

enum ChangeType {
  supplyModelChanged,
  configurationCreated,
  configurationUpdated
}

extension ChangeTypeExtension on ChangeType {
  String get value {
    switch (this) {
      case ChangeType.supplyModelChanged:
        return 'supply_model_changed';
      case ChangeType.configurationCreated:
        return 'configuration_created';
      case ChangeType.configurationUpdated:
        return 'configuration_updated';
    }
  }

  static ChangeType fromString(String value) {
    switch (value) {
      case 'supply_model_changed':
        return ChangeType.supplyModelChanged;
      case 'configuration_created':
        return ChangeType.configurationCreated;
      case 'configuration_updated':
        return ChangeType.configurationUpdated;
      default:
        return ChangeType.configurationCreated;
    }
  }
}

class SupplyConfiguration {
  final String id;
  final String organizationId;
  final String retailerId;
  final SupplyModel supplyModel;
  final bool isActive;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final String? notes;
  final int version;

  SupplyConfiguration({
    required this.id,
    required this.organizationId,
    required this.retailerId,
    this.supplyModel = SupplyModel.standingOrder,
    this.isActive = true,
    this.effectiveFrom,
    this.effectiveTo,
    this.notes,
    this.version = 1,
  });

  factory SupplyConfiguration.fromJson(Map<String, dynamic> json) {
    return SupplyConfiguration(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      supplyModel: json['supply_model'] != null
          ? SupplyModelExtension.fromString(json['supply_model'])
          : SupplyModel.standingOrder,
      isActive: json['is_active'] ?? true,
      effectiveFrom: json['effective_from'] != null
          ? DateTime.parse(json['effective_from'])
          : null,
      effectiveTo: json['effective_to'] != null
          ? DateTime.parse(json['effective_to'])
          : null,
      notes: json['notes'],
      version: json['version'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': organizationId,
    'retailer_id': retailerId,
    'supply_model': supplyModel.value,
    'is_active': isActive,
    if (effectiveFrom != null) 'effective_from': effectiveFrom!.toIso8601String(),
    if (effectiveTo != null) 'effective_to': effectiveTo!.toIso8601String(),
    if (notes != null) 'notes': notes,
    'version': version,
  };
}

class StandingOrderLine {
  final String id;
  final String skuId;
  final double quantity;
  final String unit;
  final String deliverySession;
  final String status;
  final String? specialNotes;

  StandingOrderLine({
    required this.id,
    required this.skuId,
    this.quantity = 0,
    this.unit = '',
    this.deliverySession = 'morning',
    this.status = 'active',
    this.specialNotes,
  });

  factory StandingOrderLine.fromJson(Map<String, dynamic> json) {
    return StandingOrderLine(
      id: json['id']?.toString() ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      deliverySession: json['delivery_session'] ?? 'morning',
      status: json['status'] ?? 'active',
      specialNotes: json['special_notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku_id': skuId,
    'quantity': quantity,
    'unit': unit,
    'delivery_session': deliverySession,
    'status': status,
    if (specialNotes != null) 'special_notes': specialNotes,
  };
}

class StandingOrder {
  final String id;
  final String supplyConfigId;
  final String scheduleName;
  final DeliverySession? deliverySession;
  final List<String> deliveryDays;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final bool isSuspended;
  final String? suspensionReason;
  final String? specialNotes;
  final StandingOrderStatus status;
  final List<StandingOrderLine> lines;
  final int version;

  StandingOrder({
    required this.id,
    required this.supplyConfigId,
    required this.scheduleName,
    this.deliverySession,
    this.deliveryDays = const [],
    this.effectiveFrom,
    this.effectiveTo,
    this.isSuspended = false,
    this.suspensionReason,
    this.specialNotes,
    this.status = StandingOrderStatus.active,
    this.lines = const [],
    this.version = 1,
  });

  factory StandingOrder.fromJson(Map<String, dynamic> json) {
    return StandingOrder(
      id: json['id']?.toString() ?? '',
      supplyConfigId: json['supply_config_id']?.toString() ?? '',
      scheduleName: json['schedule_name'] ?? '',
      deliverySession: json['delivery_session'] != null
          ? DeliverySessionExtension.fromString(json['delivery_session'])
          : null,
      deliveryDays: json['delivery_days'] != null
          ? List<String>.from(json['delivery_days'])
          : [],
      effectiveFrom: json['effective_from'] != null
          ? DateTime.parse(json['effective_from'])
          : null,
      effectiveTo: json['effective_to'] != null
          ? DateTime.parse(json['effective_to'])
          : null,
      isSuspended: json['is_suspended'] ?? false,
      suspensionReason: json['suspension_reason'],
      specialNotes: json['special_notes'],
      status: json['status'] != null
          ? StandingOrderStatusExtension.fromString(json['status'])
          : StandingOrderStatus.active,
      lines: json['lines'] != null
          ? (json['lines'] as List)
              .map((e) => StandingOrderLine.fromJson(e))
              .toList()
          : [],
      version: json['version'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'supply_config_id': supplyConfigId,
    'schedule_name': scheduleName,
    if (deliverySession != null) 'delivery_session': deliverySession!.value,
    'delivery_days': deliveryDays,
    if (effectiveFrom != null) 'effective_from': effectiveFrom!.toIso8601String(),
    if (effectiveTo != null) 'effective_to': effectiveTo!.toIso8601String(),
    'is_suspended': isSuspended,
    if (suspensionReason != null) 'suspension_reason': suspensionReason,
    if (specialNotes != null) 'special_notes': specialNotes,
    'status': status.value,
    'lines': lines.map((e) => e.toJson()).toList(),
    'version': version,
  };
}

class DailyOrderLine {
  final String id;
  final String skuId;
  final double quantity;
  final String unit;
  final String? notes;

  DailyOrderLine({
    required this.id,
    required this.skuId,
    this.quantity = 0,
    this.unit = '',
    this.notes,
  });

  factory DailyOrderLine.fromJson(Map<String, dynamic> json) {
    return DailyOrderLine(
      id: json['id']?.toString() ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku_id': skuId,
    'quantity': quantity,
    'unit': unit,
    if (notes != null) 'notes': notes,
  };
}

class DailyOrder {
  final String id;
  final String supplyConfigId;
  final String retailerId;
  final DateTime? orderDate;
  final String? source;
  final String? notes;
  final DailyOrderStatus status;
  final List<DailyOrderLine> lines;
  final int version;

  DailyOrder({
    required this.id,
    required this.supplyConfigId,
    required this.retailerId,
    this.orderDate,
    this.source,
    this.notes,
    this.status = DailyOrderStatus.draft,
    this.lines = const [],
    this.version = 1,
  });

  factory DailyOrder.fromJson(Map<String, dynamic> json) {
    return DailyOrder(
      id: json['id']?.toString() ?? '',
      supplyConfigId: json['supply_config_id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : null,
      source: json['source'],
      notes: json['notes'],
      status: json['status'] != null
          ? DailyOrderStatusExtension.fromString(json['status'])
          : DailyOrderStatus.draft,
      lines: json['lines'] != null
          ? (json['lines'] as List)
              .map((e) => DailyOrderLine.fromJson(e))
              .toList()
          : [],
      version: json['version'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'supply_config_id': supplyConfigId,
    'retailer_id': retailerId,
    if (orderDate != null) 'order_date': orderDate!.toIso8601String(),
    if (source != null) 'source': source,
    if (notes != null) 'notes': notes,
    'status': status.value,
    'lines': lines.map((e) => e.toJson()).toList(),
    'version': version,
  };
}

class SupplyHistory {
  final String id;
  final String organizationId;
  final String retailerId;
  final ChangeType changeType;
  final SupplyModel? previousValue;
  final SupplyModel? newValue;
  final String? notes;
  final DateTime? changedAt;
  final String? changedBy;

  SupplyHistory({
    required this.id,
    required this.organizationId,
    required this.retailerId,
    required this.changeType,
    this.previousValue,
    this.newValue,
    this.notes,
    this.changedAt,
    this.changedBy,
  });

  factory SupplyHistory.fromJson(Map<String, dynamic> json) {
    return SupplyHistory(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      changeType: json['change_type'] != null
          ? ChangeTypeExtension.fromString(json['change_type'])
          : ChangeType.configurationCreated,
      previousValue: json['previous_value'] != null
          ? SupplyModelExtension.fromString(json['previous_value'])
          : null,
      newValue: json['new_value'] != null
          ? SupplyModelExtension.fromString(json['new_value'])
          : null,
      notes: json['notes'],
      changedAt: json['changed_at'] != null
          ? DateTime.parse(json['changed_at'])
          : null,
      changedBy: json['changed_by'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': organizationId,
    'retailer_id': retailerId,
    'change_type': changeType.value,
    if (previousValue != null) 'previous_value': previousValue!.value,
    if (newValue != null) 'new_value': newValue!.value,
    if (notes != null) 'notes': notes,
    if (changedAt != null) 'changed_at': changedAt!.toIso8601String(),
    if (changedBy != null) 'changed_by': changedBy,
  };
}

class SupplyConfigCreateRequest {
  String organizationId;
  String retailerId;
  String supplyModel;
  bool isActive;
  DateTime? effectiveFrom;
  DateTime? effectiveTo;
  String? notes;

  SupplyConfigCreateRequest({
    required this.organizationId,
    required this.retailerId,
    this.supplyModel = 'standing_order',
    this.isActive = true,
    this.effectiveFrom,
    this.effectiveTo,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'organization_id': organizationId,
    'retailer_id': retailerId,
    'supply_model': supplyModel,
    'is_active': isActive,
    if (effectiveFrom != null) 'effective_from': effectiveFrom!.toIso8601String(),
    if (effectiveTo != null) 'effective_to': effectiveTo!.toIso8601String(),
    if (notes != null) 'notes': notes,
  };
}

class StandingOrderCreateRequest {
  String supplyConfigId;
  String scheduleName;
  String? deliverySession;
  List<String> deliveryDays;
  DateTime? effectiveFrom;
  DateTime? effectiveTo;
  String? specialNotes;
  List<StandingOrderLine> lines;

  StandingOrderCreateRequest({
    required this.supplyConfigId,
    required this.scheduleName,
    this.deliverySession,
    this.deliveryDays = const [],
    this.effectiveFrom,
    this.effectiveTo,
    this.specialNotes,
    this.lines = const [],
  });

  Map<String, dynamic> toJson() => {
    'supply_config_id': supplyConfigId,
    'schedule_name': scheduleName,
    if (deliverySession != null) 'delivery_session': deliverySession,
    'delivery_days': deliveryDays,
    if (effectiveFrom != null) 'effective_from': effectiveFrom!.toIso8601String(),
    if (effectiveTo != null) 'effective_to': effectiveTo!.toIso8601String(),
    if (specialNotes != null) 'special_notes': specialNotes,
    'lines': lines.map((e) => e.toJson()).toList(),
  };
}

class DailyOrderCreateRequest {
  String supplyConfigId;
  String retailerId;
  DateTime? orderDate;
  String? source;
  String? notes;
  List<DailyOrderLine> lines;

  DailyOrderCreateRequest({
    required this.supplyConfigId,
    required this.retailerId,
    this.orderDate,
    this.source,
    this.notes,
    this.lines = const [],
  });

  Map<String, dynamic> toJson() => {
    'supply_config_id': supplyConfigId,
    'retailer_id': retailerId,
    if (orderDate != null) 'order_date': orderDate!.toIso8601String(),
    if (source != null) 'source': source,
    if (notes != null) 'notes': notes,
    'lines': lines.map((e) => e.toJson()).toList(),
  };
}

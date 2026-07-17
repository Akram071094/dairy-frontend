enum MovementType { openingStock, stockIn, stockOut, return, adjustment }

extension MovementTypeExtension on MovementType {
  String get value {
    switch (this) {
      case MovementType.openingStock:
        return 'opening_stock';
      case MovementType.stockIn:
        return 'stock_in';
      case MovementType.stockOut:
        return 'stock_out';
      case MovementType.return:
        return 'return';
      case MovementType.adjustment:
        return 'adjustment';
    }
  }

  static MovementType fromString(String value) {
    switch (value) {
      case 'opening_stock':
        return MovementType.openingStock;
      case 'stock_in':
        return MovementType.stockIn;
      case 'stock_out':
        return MovementType.stockOut;
      case 'return':
        return MovementType.return;
      case 'adjustment':
        return MovementType.adjustment;
      default:
        return MovementType.stockIn;
    }
  }
}

enum AdjustmentReason { damaged, expired, lost, found, countDifference, other }

extension AdjustmentReasonExtension on AdjustmentReason {
  String get value {
    switch (this) {
      case AdjustmentReason.damaged:
        return 'damaged';
      case AdjustmentReason.expired:
        return 'expired';
      case AdjustmentReason.lost:
        return 'lost';
      case AdjustmentReason.found:
        return 'found';
      case AdjustmentReason.countDifference:
        return 'count_difference';
      case AdjustmentReason.other:
        return 'other';
    }
  }

  static AdjustmentReason fromString(String value) {
    switch (value) {
      case 'damaged':
        return AdjustmentReason.damaged;
      case 'expired':
        return AdjustmentReason.expired;
      case 'lost':
        return AdjustmentReason.lost;
      case 'found':
        return AdjustmentReason.found;
      case 'count_difference':
        return AdjustmentReason.countDifference;
      case 'other':
        return AdjustmentReason.other;
      default:
        return AdjustmentReason.other;
    }
  }
}

class Inventory {
  final String skuId;
  final String skuCode;
  final String skuName;
  final double availableQuantity;
  final double reservedQuantity;
  final double totalQuantity;
  final String unit;

  Inventory({
    required this.skuId,
    required this.skuCode,
    this.skuName = '',
    this.availableQuantity = 0,
    this.reservedQuantity = 0,
    this.totalQuantity = 0,
    this.unit = '',
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      skuId: json['sku_id']?.toString() ?? '',
      skuCode: json['sku_code'] ?? '',
      skuName: json['sku_name'] ?? '',
      availableQuantity: (json['available_quantity'] ?? 0).toDouble(),
      reservedQuantity: (json['reserved_quantity'] ?? 0).toDouble(),
      totalQuantity: (json['total_quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'sku_id': skuId,
    'sku_code': skuCode,
    'sku_name': skuName,
    'available_quantity': availableQuantity,
    'reserved_quantity': reservedQuantity,
    'total_quantity': totalQuantity,
    'unit': unit,
  };
}

class StockMovement {
  final String id;
  final String skuId;
  final MovementType? movementType;
  final double quantity;
  final String unit;
  final String? referenceId;
  final String? referenceType;
  final String? notes;
  final DateTime? effectiveDate;

  StockMovement({
    required this.id,
    required this.skuId,
    this.movementType,
    this.quantity = 0,
    this.unit = '',
    this.referenceId,
    this.referenceType,
    this.notes,
    this.effectiveDate,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id']?.toString() ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      movementType: json['movement_type'] != null
          ? MovementTypeExtension.fromString(json['movement_type'])
          : null,
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      referenceId: json['reference_id']?.toString(),
      referenceType: json['reference_type'],
      notes: json['notes'],
      effectiveDate: json['effective_date'] != null
          ? DateTime.parse(json['effective_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku_id': skuId,
    if (movementType != null) 'movement_type': movementType!.value,
    'quantity': quantity,
    'unit': unit,
    if (referenceId != null) 'reference_id': referenceId,
    if (referenceType != null) 'reference_type': referenceType,
    if (notes != null) 'notes': notes,
    if (effectiveDate != null) 'effective_date': effectiveDate!.toIso8601String(),
  };
}

class InventorySummary {
  final int totalSkus;
  final double totalAvailableQuantity;
  final double totalReservedQuantity;
  final int lowStockCount;
  final int outOfStockCount;
  final DateTime? lastUpdated;

  InventorySummary({
    this.totalSkus = 0,
    this.totalAvailableQuantity = 0,
    this.totalReservedQuantity = 0,
    this.lowStockCount = 0,
    this.outOfStockCount = 0,
    this.lastUpdated,
  });

  factory InventorySummary.fromJson(Map<String, dynamic> json) {
    return InventorySummary(
      totalSkus: json['total_skus'] ?? 0,
      totalAvailableQuantity: (json['total_available_quantity'] ?? 0).toDouble(),
      totalReservedQuantity: (json['total_reserved_quantity'] ?? 0).toDouble(),
      lowStockCount: json['low_stock_count'] ?? 0,
      outOfStockCount: json['out_of_stock_count'] ?? 0,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_skus': totalSkus,
    'total_available_quantity': totalAvailableQuantity,
    'total_reserved_quantity': totalReservedQuantity,
    'low_stock_count': lowStockCount,
    'out_of_stock_count': outOfStockCount,
    if (lastUpdated != null) 'last_updated': lastUpdated!.toIso8601String(),
  };
}

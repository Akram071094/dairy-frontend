enum VisitStatus { pending, started, delivered, completed, skipped }

extension VisitStatusExtension on VisitStatus {
  String get value {
    switch (this) {
      case VisitStatus.pending:
        return 'pending';
      case VisitStatus.started:
        return 'started';
      case VisitStatus.delivered:
        return 'delivered';
      case VisitStatus.completed:
        return 'completed';
      case VisitStatus.skipped:
        return 'skipped';
    }
  }

  static VisitStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return VisitStatus.pending;
      case 'started':
        return VisitStatus.started;
      case 'delivered':
        return VisitStatus.delivered;
      case 'completed':
        return VisitStatus.completed;
      case 'skipped':
        return VisitStatus.skipped;
      default:
        return VisitStatus.pending;
    }
  }
}

enum DeliveredItemStatus { delivered, partial }

extension DeliveredItemStatusExtension on DeliveredItemStatus {
  String get value {
    switch (this) {
      case DeliveredItemStatus.delivered:
        return 'delivered';
      case DeliveredItemStatus.partial:
        return 'partial';
    }
  }

  static DeliveredItemStatus fromString(String value) {
    switch (value) {
      case 'delivered':
        return DeliveredItemStatus.delivered;
      case 'partial':
        return DeliveredItemStatus.partial;
      default:
        return DeliveredItemStatus.delivered;
    }
  }
}

enum ReturnReason { damaged, expired, wrongProduct, customerRejected, other }

extension ReturnReasonExtension on ReturnReason {
  String get value {
    switch (this) {
      case ReturnReason.damaged:
        return 'damaged';
      case ReturnReason.expired:
        return 'expired';
      case ReturnReason.wrongProduct:
        return 'wrong_product';
      case ReturnReason.customerRejected:
        return 'customer_rejected';
      case ReturnReason.other:
        return 'other';
    }
  }

  static ReturnReason fromString(String value) {
    switch (value) {
      case 'damaged':
        return ReturnReason.damaged;
      case 'expired':
        return ReturnReason.expired;
      case 'wrong_product':
        return ReturnReason.wrongProduct;
      case 'customer_rejected':
        return ReturnReason.customerRejected;
      case 'other':
        return ReturnReason.other;
      default:
        return ReturnReason.other;
    }
  }
}

enum ExecutionExceptionSeverity { warning, error, critical }

extension ExecutionExceptionSeverityExtension on ExecutionExceptionSeverity {
  String get value {
    switch (this) {
      case ExecutionExceptionSeverity.warning:
        return 'warning';
      case ExecutionExceptionSeverity.error:
        return 'error';
      case ExecutionExceptionSeverity.critical:
        return 'critical';
    }
  }

  static ExecutionExceptionSeverity fromString(String value) {
    switch (value) {
      case 'warning':
        return ExecutionExceptionSeverity.warning;
      case 'error':
        return ExecutionExceptionSeverity.error;
      case 'critical':
        return ExecutionExceptionSeverity.critical;
      default:
        return ExecutionExceptionSeverity.warning;
    }
  }
}

class SupplyExecution {
  final String id;
  final String manifestId;
  final String assignmentId;
  final DateTime? manifestDate;
  final String deliveryStaffId;
  final String status;
  final int totalRetailers;
  final int completedRetailers;
  final int skippedRetailers;
  final int totalItems;
  final double totalDeliveredQuantity;
  final double totalReturnedQuantity;
  final double totalAdditionalSales;
  final DateTime? startedAt;

  SupplyExecution({
    required this.id,
    required this.manifestId,
    required this.assignmentId,
    this.manifestDate,
    required this.deliveryStaffId,
    this.status = 'in_progress',
    this.totalRetailers = 0,
    this.completedRetailers = 0,
    this.skippedRetailers = 0,
    this.totalItems = 0,
    this.totalDeliveredQuantity = 0,
    this.totalReturnedQuantity = 0,
    this.totalAdditionalSales = 0,
    this.startedAt,
  });

  factory SupplyExecution.fromJson(Map<String, dynamic> json) {
    return SupplyExecution(
      id: json['id']?.toString() ?? '',
      manifestId: json['manifest_id']?.toString() ?? '',
      assignmentId: json['assignment_id']?.toString() ?? '',
      manifestDate: json['manifest_date'] != null
          ? DateTime.parse(json['manifest_date'])
          : null,
      deliveryStaffId: json['delivery_staff_id']?.toString() ?? '',
      status: json['status'] ?? 'in_progress',
      totalRetailers: json['total_retailers'] ?? 0,
      completedRetailers: json['completed_retailers'] ?? 0,
      skippedRetailers: json['skipped_retailers'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      totalDeliveredQuantity: (json['total_delivered_quantity'] ?? 0).toDouble(),
      totalReturnedQuantity: (json['total_returned_quantity'] ?? 0).toDouble(),
      totalAdditionalSales: (json['total_additional_sales'] ?? 0).toDouble(),
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'manifest_id': manifestId,
    'assignment_id': assignmentId,
    if (manifestDate != null) 'manifest_date': manifestDate!.toIso8601String(),
    'delivery_staff_id': deliveryStaffId,
    'status': status,
    'total_retailers': totalRetailers,
    'completed_retailers': completedRetailers,
    'skipped_retailers': skippedRetailers,
    'total_items': totalItems,
    'total_delivered_quantity': totalDeliveredQuantity,
    'total_returned_quantity': totalReturnedQuantity,
    'total_additional_sales': totalAdditionalSales,
    if (startedAt != null) 'started_at': startedAt!.toIso8601String(),
  };
}

class RetailerVisit {
  final String id;
  final String executionId;
  final String retailerId;
  final String retailerName;
  final String deliverySession;
  final String supplyModel;
  final VisitStatus status;
  final int visitOrder;
  final int totalAssignedItems;
  final int totalDeliveredItems;
  final double totalDeliveredQuantity;
  final double totalReturnedQuantity;
  final double totalAdditionalAmount;
  final String? specialInstructions;
  final DateTime? startedAt;
  final DateTime? completedAt;

  RetailerVisit({
    required this.id,
    required this.executionId,
    required this.retailerId,
    this.retailerName = '',
    this.deliverySession = 'morning',
    this.supplyModel = '',
    this.status = VisitStatus.pending,
    this.visitOrder = 0,
    this.totalAssignedItems = 0,
    this.totalDeliveredItems = 0,
    this.totalDeliveredQuantity = 0,
    this.totalReturnedQuantity = 0,
    this.totalAdditionalAmount = 0,
    this.specialInstructions,
    this.startedAt,
    this.completedAt,
  });

  factory RetailerVisit.fromJson(Map<String, dynamic> json) {
    return RetailerVisit(
      id: json['id']?.toString() ?? '',
      executionId: json['execution_id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      retailerName: json['retailer_name'] ?? '',
      deliverySession: json['delivery_session'] ?? 'morning',
      supplyModel: json['supply_model'] ?? '',
      status: json['status'] != null
          ? VisitStatusExtension.fromString(json['status'])
          : VisitStatus.pending,
      visitOrder: json['visit_order'] ?? 0,
      totalAssignedItems: json['total_assigned_items'] ?? 0,
      totalDeliveredItems: json['total_delivered_items'] ?? 0,
      totalDeliveredQuantity: (json['total_delivered_quantity'] ?? 0).toDouble(),
      totalReturnedQuantity: (json['total_returned_quantity'] ?? 0).toDouble(),
      totalAdditionalAmount: (json['total_additional_amount'] ?? 0).toDouble(),
      specialInstructions: json['special_instructions'],
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'execution_id': executionId,
    'retailer_id': retailerId,
    'retailer_name': retailerName,
    'delivery_session': deliverySession,
    'supply_model': supplyModel,
    'status': status.value,
    'visit_order': visitOrder,
    'total_assigned_items': totalAssignedItems,
    'total_delivered_items': totalDeliveredItems,
    'total_delivered_quantity': totalDeliveredQuantity,
    'total_returned_quantity': totalReturnedQuantity,
    'total_additional_amount': totalAdditionalAmount,
    if (specialInstructions != null) 'special_instructions': specialInstructions,
    if (startedAt != null) 'started_at': startedAt!.toIso8601String(),
    if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
  };
}

class DeliveredItem {
  final String id;
  final String manifestItemId;
  final String skuId;
  final String skuName;
  final double assignedQuantity;
  final double deliveredQuantity;
  final double returnedQuantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final bool isPartial;
  final String? shortSupplyReason;
  final DeliveredItemStatus status;

  DeliveredItem({
    required this.id,
    required this.manifestItemId,
    required this.skuId,
    this.skuName = '',
    this.assignedQuantity = 0,
    this.deliveredQuantity = 0,
    this.returnedQuantity = 0,
    this.unit = '',
    this.unitPrice = 0,
    this.totalPrice = 0,
    this.isPartial = false,
    this.shortSupplyReason,
    this.status = DeliveredItemStatus.delivered,
  });

  factory DeliveredItem.fromJson(Map<String, dynamic> json) {
    return DeliveredItem(
      id: json['id']?.toString() ?? '',
      manifestItemId: json['manifest_item_id']?.toString() ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      skuName: json['sku_name'] ?? '',
      assignedQuantity: (json['assigned_quantity'] ?? 0).toDouble(),
      deliveredQuantity: (json['delivered_quantity'] ?? 0).toDouble(),
      returnedQuantity: (json['returned_quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      isPartial: json['is_partial'] ?? false,
      shortSupplyReason: json['short_supply_reason'],
      status: json['status'] != null
          ? DeliveredItemStatusExtension.fromString(json['status'])
          : DeliveredItemStatus.delivered,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'manifest_item_id': manifestItemId,
    'sku_id': skuId,
    'sku_name': skuName,
    'assigned_quantity': assignedQuantity,
    'delivered_quantity': deliveredQuantity,
    'returned_quantity': returnedQuantity,
    'unit': unit,
    'unit_price': unitPrice,
    'total_price': totalPrice,
    'is_partial': isPartial,
    if (shortSupplyReason != null) 'short_supply_reason': shortSupplyReason,
    'status': status.value,
  };
}

class AdditionalSale {
  final String id;
  final String skuId;
  final String skuName;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final String? notes;

  AdditionalSale({
    required this.id,
    required this.skuId,
    this.skuName = '',
    this.quantity = 0,
    this.unit = '',
    this.unitPrice = 0,
    this.totalPrice = 0,
    this.notes,
  });

  factory AdditionalSale.fromJson(Map<String, dynamic> json) {
    return AdditionalSale(
      id: json['id']?.toString() ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      skuName: json['sku_name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku_id': skuId,
    'sku_name': skuName,
    'quantity': quantity,
    'unit': unit,
    'unit_price': unitPrice,
    'total_price': totalPrice,
    if (notes != null) 'notes': notes,
  };
}

class ReturnedItem {
  final String id;
  final String deliveredItemId;
  final String skuId;
  final String skuName;
  final double quantity;
  final String unit;
  final ReturnReason? returnReason;
  final String? returnNotes;

  ReturnedItem({
    required this.id,
    required this.deliveredItemId,
    required this.skuId,
    this.skuName = '',
    this.quantity = 0,
    this.unit = '',
    this.returnReason,
    this.returnNotes,
  });

  factory ReturnedItem.fromJson(Map<String, dynamic> json) {
    return ReturnedItem(
      id: json['id']?.toString() ?? '',
      deliveredItemId: json['delivered_item_id']?.toString() ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      skuName: json['sku_name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      returnReason: json['return_reason'] != null
          ? ReturnReasonExtension.fromString(json['return_reason'])
          : null,
      returnNotes: json['return_notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'delivered_item_id': deliveredItemId,
    'sku_id': skuId,
    'sku_name': skuName,
    'quantity': quantity,
    'unit': unit,
    if (returnReason != null) 'return_reason': returnReason!.value,
    if (returnNotes != null) 'return_notes': returnNotes,
  };
}

class DeliveryException {
  final String id;
  final String visitId;
  final String exceptionType;
  final ExecutionExceptionSeverity severity;
  final String exceptionMessage;
  final String? exceptionDetails;
  final String status;

  DeliveryException({
    required this.id,
    required this.visitId,
    required this.exceptionType,
    this.severity = ExecutionExceptionSeverity.warning,
    required this.exceptionMessage,
    this.exceptionDetails,
    this.status = 'open',
  });

  factory DeliveryException.fromJson(Map<String, dynamic> json) {
    return DeliveryException(
      id: json['id']?.toString() ?? '',
      visitId: json['visit_id']?.toString() ?? '',
      exceptionType: json['exception_type'] ?? '',
      severity: json['severity'] != null
          ? ExecutionExceptionSeverityExtension.fromString(json['severity'])
          : ExecutionExceptionSeverity.warning,
      exceptionMessage: json['exception_message'] ?? '',
      exceptionDetails: json['exception_details'],
      status: json['status'] ?? 'open',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'visit_id': visitId,
    'exception_type': exceptionType,
    'severity': severity.value,
    'exception_message': exceptionMessage,
    if (exceptionDetails != null) 'exception_details': exceptionDetails,
    'status': status,
  };
}

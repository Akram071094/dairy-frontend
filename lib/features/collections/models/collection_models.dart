enum CollectionStatus { completed, pending, verified, cancelled }

extension CollectionStatusExtension on CollectionStatus {
  String get value {
    switch (this) {
      case CollectionStatus.completed:
        return 'completed';
      case CollectionStatus.pending:
        return 'pending';
      case CollectionStatus.verified:
        return 'verified';
      case CollectionStatus.cancelled:
        return 'cancelled';
    }
  }

  static CollectionStatus fromString(String value) {
    switch (value) {
      case 'completed':
        return CollectionStatus.completed;
      case 'pending':
        return CollectionStatus.pending;
      case 'verified':
        return CollectionStatus.verified;
      case 'cancelled':
        return CollectionStatus.cancelled;
      default:
        return CollectionStatus.pending;
    }
  }
}

enum CollectionPaymentMethod { cash, upi, bankTransfer, cheque, mixed }

extension CollectionPaymentMethodExtension on CollectionPaymentMethod {
  String get value {
    switch (this) {
      case CollectionPaymentMethod.cash:
        return 'cash';
      case CollectionPaymentMethod.upi:
        return 'upi';
      case CollectionPaymentMethod.bankTransfer:
        return 'bank_transfer';
      case CollectionPaymentMethod.cheque:
        return 'cheque';
      case CollectionPaymentMethod.mixed:
        return 'mixed';
    }
  }

  static CollectionPaymentMethod fromString(String value) {
    switch (value) {
      case 'cash':
        return CollectionPaymentMethod.cash;
      case 'upi':
        return CollectionPaymentMethod.upi;
      case 'bank_transfer':
        return CollectionPaymentMethod.bankTransfer;
      case 'cheque':
        return CollectionPaymentMethod.cheque;
      case 'mixed':
        return CollectionPaymentMethod.mixed;
      default:
        return CollectionPaymentMethod.cash;
    }
  }
}

enum CreditStatus { active, suspended, closed }

extension CreditStatusExtension on CreditStatus {
  String get value {
    switch (this) {
      case CreditStatus.active:
        return 'active';
      case CreditStatus.suspended:
        return 'suspended';
      case CreditStatus.closed:
        return 'closed';
    }
  }

  static CreditStatus fromString(String value) {
    switch (value) {
      case 'active':
        return CreditStatus.active;
      case 'suspended':
        return CreditStatus.suspended;
      case 'closed':
        return CreditStatus.closed;
      default:
        return CreditStatus.active;
    }
  }
}

enum ExceptionType { overduePayment, paymentMismatch, collectionFailed }

extension ExceptionTypeExtension on ExceptionType {
  String get value {
    switch (this) {
      case ExceptionType.overduePayment:
        return 'overdue_payment';
      case ExceptionType.paymentMismatch:
        return 'payment_mismatch';
      case ExceptionType.collectionFailed:
        return 'collection_failed';
    }
  }

  static ExceptionType fromString(String value) {
    switch (value) {
      case 'overdue_payment':
        return ExceptionType.overduePayment;
      case 'payment_mismatch':
        return ExceptionType.paymentMismatch;
      case 'collection_failed':
        return ExceptionType.collectionFailed;
      default:
        return ExceptionType.overduePayment;
    }
  }
}

class Collection {
  final String id;
  final String retailerId;
  final double amount;
  final CollectionPaymentMethod? paymentMethod;
  final String? referenceNumber;
  final String? notes;
  final String? deliveryExecutionId;
  final CollectionStatus? status;
  final String? collectedBy;
  final DateTime? collectedAt;

  Collection({
    required this.id,
    required this.retailerId,
    required this.amount,
    this.paymentMethod,
    this.referenceNumber,
    this.notes,
    this.deliveryExecutionId,
    this.status,
    this.collectedBy,
    this.collectedAt,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] != null
          ? CollectionPaymentMethodExtension.fromString(json['payment_method'])
          : null,
      referenceNumber: json['reference_number'],
      notes: json['notes'],
      deliveryExecutionId: json['delivery_execution_id']?.toString(),
      status: json['status'] != null
          ? CollectionStatusExtension.fromString(json['status'])
          : null,
      collectedBy: json['collected_by'],
      collectedAt: json['collected_at'] != null
          ? DateTime.parse(json['collected_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'retailer_id': retailerId,
    'amount': amount,
    if (paymentMethod != null) 'payment_method': paymentMethod!.value,
    if (referenceNumber != null) 'reference_number': referenceNumber,
    if (notes != null) 'notes': notes,
    if (deliveryExecutionId != null) 'delivery_execution_id': deliveryExecutionId,
    if (status != null) 'status': status!.value,
    if (collectedBy != null) 'collected_by': collectedBy,
    if (collectedAt != null) 'collected_at': collectedAt!.toIso8601String(),
  };
}

class Outstanding {
  final String id;
  final String retailerId;
  final double outstandingAmount;
  final double creditLimit;
  final double availableCredit;
  final double overdueAmount;
  final DateTime? lastPaymentDate;
  final double lastPaymentAmount;

  Outstanding({
    required this.id,
    required this.retailerId,
    this.outstandingAmount = 0,
    this.creditLimit = 0,
    this.availableCredit = 0,
    this.overdueAmount = 0,
    this.lastPaymentDate,
    this.lastPaymentAmount = 0,
  });

  factory Outstanding.fromJson(Map<String, dynamic> json) {
    return Outstanding(
      id: json['id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      outstandingAmount: (json['outstanding_amount'] ?? 0).toDouble(),
      creditLimit: (json['credit_limit'] ?? 0).toDouble(),
      availableCredit: (json['available_credit'] ?? 0).toDouble(),
      overdueAmount: (json['overdue_amount'] ?? 0).toDouble(),
      lastPaymentDate: json['last_payment_date'] != null
          ? DateTime.parse(json['last_payment_date'])
          : null,
      lastPaymentAmount: (json['last_payment_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'retailer_id': retailerId,
    'outstanding_amount': outstandingAmount,
    'credit_limit': creditLimit,
    'available_credit': availableCredit,
    'overdue_amount': overdueAmount,
    if (lastPaymentDate != null) 'last_payment_date': lastPaymentDate!.toIso8601String(),
    'last_payment_amount': lastPaymentAmount,
  };
}

class Credit {
  final String id;
  final String retailerId;
  final double creditLimit;
  final double availableCredit;
  final double creditUsed;
  final CreditStatus? creditStatus;

  Credit({
    required this.id,
    required this.retailerId,
    this.creditLimit = 0,
    this.availableCredit = 0,
    this.creditUsed = 0,
    this.creditStatus,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      id: json['id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      creditLimit: (json['credit_limit'] ?? 0).toDouble(),
      availableCredit: (json['available_credit'] ?? 0).toDouble(),
      creditUsed: (json['credit_used'] ?? 0).toDouble(),
      creditStatus: json['credit_status'] != null
          ? CreditStatusExtension.fromString(json['credit_status'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'retailer_id': retailerId,
    'credit_limit': creditLimit,
    'available_credit': availableCredit,
    'credit_used': creditUsed,
    if (creditStatus != null) 'credit_status': creditStatus!.value,
  };
}

class CollectionException {
  final String id;
  final String retailerId;
  final ExceptionType? exceptionType;
  final String description;
  final double amount;
  final String status;

  CollectionException({
    required this.id,
    required this.retailerId,
    this.exceptionType,
    required this.description,
    this.amount = 0,
    this.status = 'open',
  });

  factory CollectionException.fromJson(Map<String, dynamic> json) {
    return CollectionException(
      id: json['id']?.toString() ?? '',
      retailerId: json['retailer_id']?.toString() ?? '',
      exceptionType: json['exception_type'] != null
          ? ExceptionTypeExtension.fromString(json['exception_type'])
          : null,
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'open',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'retailer_id': retailerId,
    if (exceptionType != null) 'exception_type': exceptionType!.value,
    'description': description,
    'amount': amount,
    'status': status,
  };
}

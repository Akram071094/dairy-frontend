enum RetailerStatus { draft, active, inactive, suspended, archived }

extension RetailerStatusExtension on RetailerStatus {
  String get value {
    switch (this) {
      case RetailerStatus.draft:
        return 'draft';
      case RetailerStatus.active:
        return 'active';
      case RetailerStatus.inactive:
        return 'inactive';
      case RetailerStatus.suspended:
        return 'suspended';
      case RetailerStatus.archived:
        return 'archived';
    }
  }

  static RetailerStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return RetailerStatus.draft;
      case 'active':
        return RetailerStatus.active;
      case 'inactive':
        return RetailerStatus.inactive;
      case 'suspended':
        return RetailerStatus.suspended;
      case 'archived':
        return RetailerStatus.archived;
      default:
        return RetailerStatus.draft;
    }
  }
}

enum ContactRole { owner, manager, cashier, purchaseManager, other }

extension ContactRoleExtension on ContactRole {
  String get value {
    switch (this) {
      case ContactRole.owner:
        return 'owner';
      case ContactRole.manager:
        return 'manager';
      case ContactRole.cashier:
        return 'cashier';
      case ContactRole.purchaseManager:
        return 'purchase_manager';
      case ContactRole.other:
        return 'other';
    }
  }

  static ContactRole fromString(String value) {
    switch (value) {
      case 'owner':
        return ContactRole.owner;
      case 'manager':
        return ContactRole.manager;
      case 'cashier':
        return ContactRole.cashier;
      case 'purchase_manager':
        return ContactRole.purchaseManager;
      case 'other':
        return ContactRole.other;
      default:
        return ContactRole.other;
    }
  }
}

enum AddressType { billing, delivery, branch, business, shipping, warehouse }

extension AddressTypeExtension on AddressType {
  String get value {
    switch (this) {
      case AddressType.billing:
        return 'billing';
      case AddressType.delivery:
        return 'delivery';
      case AddressType.branch:
        return 'branch';
      case AddressType.business:
        return 'business';
      case AddressType.shipping:
        return 'shipping';
      case AddressType.warehouse:
        return 'warehouse';
    }
  }

  static AddressType fromString(String value) {
    switch (value) {
      case 'billing':
        return AddressType.billing;
      case 'delivery':
        return AddressType.delivery;
      case 'branch':
        return AddressType.branch;
      case 'business':
        return AddressType.business;
      case 'shipping':
        return AddressType.shipping;
      case 'warehouse':
        return AddressType.warehouse;
      default:
        return AddressType.business;
    }
  }
}

enum DeliverySession { morning, evening, both }

extension DeliverySessionExtension on DeliverySession {
  String get value {
    switch (this) {
      case DeliverySession.morning:
        return 'morning';
      case DeliverySession.evening:
        return 'evening';
      case DeliverySession.both:
        return 'both';
    }
  }

  static DeliverySession fromString(String value) {
    switch (value) {
      case 'morning':
        return DeliverySession.morning;
      case 'evening':
        return DeliverySession.evening;
      case 'both':
        return DeliverySession.both;
      default:
        return DeliverySession.morning;
    }
  }
}

enum PaymentMethod { cash, upi, bankTransfer, cheque, mixed }

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.upi:
        return 'upi';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.cheque:
        return 'cheque';
      case PaymentMethod.mixed:
        return 'mixed';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value) {
      case 'cash':
        return PaymentMethod.cash;
      case 'upi':
        return PaymentMethod.upi;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'cheque':
        return PaymentMethod.cheque;
      case 'mixed':
        return PaymentMethod.mixed;
      default:
        return PaymentMethod.cash;
    }
  }
}

enum CollectionPriority { high, medium, low }

extension CollectionPriorityExtension on CollectionPriority {
  String get value {
    switch (this) {
      case CollectionPriority.high:
        return 'high';
      case CollectionPriority.medium:
        return 'medium';
      case CollectionPriority.low:
        return 'low';
    }
  }

  static CollectionPriority fromString(String value) {
    switch (value) {
      case 'high':
        return CollectionPriority.high;
      case 'medium':
        return CollectionPriority.medium;
      case 'low':
        return CollectionPriority.low;
      default:
        return CollectionPriority.medium;
    }
  }
}

class BusinessCategory {
  final String id;
  final String code;
  final String name;
  final String? description;
  final bool isActive;

  BusinessCategory({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.isActive = true,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) {
    return BusinessCategory(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    if (description != null) 'description': description,
    'is_active': isActive,
  };
}

class Retailer {
  final String id;
  final String businessCode;
  final String displayName;
  final RetailerStatus status;
  final BusinessCategory? businessCategory;
  final String? areaId;
  final String? areaName;
  final String? ownerName;
  final String? primaryContact;
  final String? secondaryContact;
  final String? email;
  final String? preferredLanguage;
  final bool creditEnabled;
  final double currentOutstanding;
  final DateTime? createdAt;

  Retailer({
    required this.id,
    required this.businessCode,
    required this.displayName,
    this.status = RetailerStatus.draft,
    this.businessCategory,
    this.areaId,
    this.areaName,
    this.ownerName,
    this.primaryContact,
    this.secondaryContact,
    this.email,
    this.preferredLanguage,
    this.creditEnabled = false,
    this.currentOutstanding = 0,
    this.createdAt,
  });

  factory Retailer.fromJson(Map<String, dynamic> json) {
    return Retailer(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? '',
      displayName: json['display_name'] ?? '',
      status: json['status'] != null
          ? RetailerStatusExtension.fromString(json['status'])
          : RetailerStatus.draft,
      businessCategory: json['business_category'] != null
          ? BusinessCategory.fromJson(json['business_category'])
          : null,
      areaId: json['area_id']?.toString(),
      areaName: json['area_name'],
      ownerName: json['owner_name'],
      primaryContact: json['primary_contact'],
      secondaryContact: json['secondary_contact'],
      email: json['email'],
      preferredLanguage: json['preferred_language'],
      creditEnabled: json['credit_enabled'] ?? false,
      currentOutstanding: (json['current_outstanding'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_code': businessCode,
    'display_name': displayName,
    'status': status.value,
    if (businessCategory != null) 'business_category': businessCategory!.toJson(),
    if (areaId != null) 'area_id': areaId,
    if (areaName != null) 'area_name': areaName,
    if (ownerName != null) 'owner_name': ownerName,
    if (primaryContact != null) 'primary_contact': primaryContact,
    if (secondaryContact != null) 'secondary_contact': secondaryContact,
    if (email != null) 'email': email,
    if (preferredLanguage != null) 'preferred_language': preferredLanguage,
    'credit_enabled': creditEnabled,
    'current_outstanding': currentOutstanding,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
  };
}

class RetailerContact {
  final String id;
  final String name;
  final ContactRole role;
  final String? mobile;
  final String? email;
  final String? whatsappNumber;
  final bool isPrimary;

  RetailerContact({
    required this.id,
    required this.name,
    this.role = ContactRole.other,
    this.mobile,
    this.email,
    this.whatsappNumber,
    this.isPrimary = false,
  });

  factory RetailerContact.fromJson(Map<String, dynamic> json) {
    return RetailerContact(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      role: json['role'] != null
          ? ContactRoleExtension.fromString(json['role'])
          : ContactRole.other,
      mobile: json['mobile'],
      email: json['email'],
      whatsappNumber: json['whatsapp_number'],
      isPrimary: json['is_primary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role.value,
    if (mobile != null) 'mobile': mobile,
    if (email != null) 'email': email,
    if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
    'is_primary': isPrimary,
  };
}

class RetailerAddress {
  final String id;
  final AddressType addressType;
  final String? country;
  final String? state;
  final String? district;
  final String? city;
  final String? areaName;
  final String? street;
  final String? landmark;
  final String? postalCode;
  final bool isDefault;

  RetailerAddress({
    required this.id,
    this.addressType = AddressType.business,
    this.country,
    this.state,
    this.district,
    this.city,
    this.areaName,
    this.street,
    this.landmark,
    this.postalCode,
    this.isDefault = false,
  });

  factory RetailerAddress.fromJson(Map<String, dynamic> json) {
    return RetailerAddress(
      id: json['id']?.toString() ?? '',
      addressType: json['address_type'] != null
          ? AddressTypeExtension.fromString(json['address_type'])
          : AddressType.business,
      country: json['country'],
      state: json['state'],
      district: json['district'],
      city: json['city'],
      areaName: json['area_name'],
      street: json['street'],
      landmark: json['landmark'],
      postalCode: json['postal_code'],
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'address_type': addressType.value,
    if (country != null) 'country': country,
    if (state != null) 'state': state,
    if (district != null) 'district': district,
    if (city != null) 'city': city,
    if (areaName != null) 'area_name': areaName,
    if (street != null) 'street': street,
    if (landmark != null) 'landmark': landmark,
    if (postalCode != null) 'postal_code': postalCode,
    'is_default': isDefault,
  };
}

class DeliveryPreferences {
  final DeliverySession? deliverySession;
  final String? preferredTimeWindow;
  final String? specialInstructions;

  DeliveryPreferences({
    this.deliverySession,
    this.preferredTimeWindow,
    this.specialInstructions,
  });

  factory DeliveryPreferences.fromJson(Map<String, dynamic> json) {
    return DeliveryPreferences(
      deliverySession: json['delivery_session'] != null
          ? DeliverySessionExtension.fromString(json['delivery_session'])
          : null,
      preferredTimeWindow: json['preferred_time_window'],
      specialInstructions: json['special_instructions'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (deliverySession != null) 'delivery_session': deliverySession!.value,
    if (preferredTimeWindow != null) 'preferred_time_window': preferredTimeWindow,
    if (specialInstructions != null) 'special_instructions': specialInstructions,
  };
}

class CollectionPreferences {
  final PaymentMethod? preferredPaymentMethod;
  final String? preferredCollectionDay;
  final String? preferredCollectionTime;
  final CollectionPriority? collectionPriority;
  final String? specialInstructions;

  CollectionPreferences({
    this.preferredPaymentMethod,
    this.preferredCollectionDay,
    this.preferredCollectionTime,
    this.collectionPriority,
    this.specialInstructions,
  });

  factory CollectionPreferences.fromJson(Map<String, dynamic> json) {
    return CollectionPreferences(
      preferredPaymentMethod: json['preferred_payment_method'] != null
          ? PaymentMethodExtension.fromString(json['preferred_payment_method'])
          : null,
      preferredCollectionDay: json['preferred_collection_day'],
      preferredCollectionTime: json['preferred_collection_time'],
      collectionPriority: json['collection_priority'] != null
          ? CollectionPriorityExtension.fromString(json['collection_priority'])
          : null,
      specialInstructions: json['special_instructions'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (preferredPaymentMethod != null) 'preferred_payment_method': preferredPaymentMethod!.value,
    if (preferredCollectionDay != null) 'preferred_collection_day': preferredCollectionDay,
    if (preferredCollectionTime != null) 'preferred_collection_time': preferredCollectionTime,
    if (collectionPriority != null) 'collection_priority': collectionPriority!.value,
    if (specialInstructions != null) 'special_instructions': specialInstructions,
  };
}

class CreditProfile {
  final bool creditEnabled;
  final double creditLimit;
  final int creditDays;
  final double maximumOutstanding;
  final String? collectionPriority;
  final double currentOutstanding;
  final double availableCredit;

  CreditProfile({
    this.creditEnabled = false,
    this.creditLimit = 0,
    this.creditDays = 0,
    this.maximumOutstanding = 0,
    this.collectionPriority,
    this.currentOutstanding = 0,
    this.availableCredit = 0,
  });

  factory CreditProfile.fromJson(Map<String, dynamic> json) {
    return CreditProfile(
      creditEnabled: json['credit_enabled'] ?? false,
      creditLimit: (json['credit_limit'] ?? 0).toDouble(),
      creditDays: json['credit_days'] ?? 0,
      maximumOutstanding: (json['maximum_outstanding'] ?? 0).toDouble(),
      collectionPriority: json['collection_priority'],
      currentOutstanding: (json['current_outstanding'] ?? 0).toDouble(),
      availableCredit: (json['available_credit'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'credit_enabled': creditEnabled,
    'credit_limit': creditLimit,
    'credit_days': creditDays,
    'maximum_outstanding': maximumOutstanding,
    if (collectionPriority != null) 'collection_priority': collectionPriority,
    'current_outstanding': currentOutstanding,
    'available_credit': availableCredit,
  };
}

class OutstandingSummary {
  final double totalOutstanding;
  final double currentOutstanding;
  final double overdueAmount;
  final int overdueDays;
  final double creditLimit;
  final double availableCredit;
  final DateTime? lastPaymentDate;
  final double lastPaymentAmount;

  OutstandingSummary({
    this.totalOutstanding = 0,
    this.currentOutstanding = 0,
    this.overdueAmount = 0,
    this.overdueDays = 0,
    this.creditLimit = 0,
    this.availableCredit = 0,
    this.lastPaymentDate,
    this.lastPaymentAmount = 0,
  });

  factory OutstandingSummary.fromJson(Map<String, dynamic> json) {
    return OutstandingSummary(
      totalOutstanding: (json['total_outstanding'] ?? 0).toDouble(),
      currentOutstanding: (json['current_outstanding'] ?? 0).toDouble(),
      overdueAmount: (json['overdue_amount'] ?? 0).toDouble(),
      overdueDays: json['overdue_days'] ?? 0,
      creditLimit: (json['credit_limit'] ?? 0).toDouble(),
      availableCredit: (json['available_credit'] ?? 0).toDouble(),
      lastPaymentDate: json['last_payment_date'] != null
          ? DateTime.parse(json['last_payment_date'])
          : null,
      lastPaymentAmount: (json['last_payment_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'total_outstanding': totalOutstanding,
    'current_outstanding': currentOutstanding,
    'overdue_amount': overdueAmount,
    'overdue_days': overdueDays,
    'credit_limit': creditLimit,
    'available_credit': availableCredit,
    if (lastPaymentDate != null) 'last_payment_date': lastPaymentDate!.toIso8601String(),
    'last_payment_amount': lastPaymentAmount,
  };
}

class RetailerCreateRequest {
  String businessCode;
  String displayName;
  String? businessCategoryId;
  String? areaId;
  String? areaName;
  String? ownerName;
  String? primaryContact;
  String? secondaryContact;
  String? email;
  String? preferredLanguage;
  bool creditEnabled;

  RetailerCreateRequest({
    required this.businessCode,
    required this.displayName,
    this.businessCategoryId,
    this.areaId,
    this.areaName,
    this.ownerName,
    this.primaryContact,
    this.secondaryContact,
    this.email,
    this.preferredLanguage,
    this.creditEnabled = false,
  });

  Map<String, dynamic> toJson() => {
    'business_code': businessCode,
    'display_name': displayName,
    if (businessCategoryId != null) 'business_category_id': businessCategoryId,
    if (areaId != null) 'area_id': areaId,
    if (areaName != null) 'area_name': areaName,
    if (ownerName != null) 'owner_name': ownerName,
    if (primaryContact != null) 'primary_contact': primaryContact,
    if (secondaryContact != null) 'secondary_contact': secondaryContact,
    if (email != null) 'email': email,
    if (preferredLanguage != null) 'preferred_language': preferredLanguage,
    'credit_enabled': creditEnabled,
  };
}

class RetailerContactRequest {
  String name;
  String role;
  String? mobile;
  String? email;
  String? whatsappNumber;
  bool isPrimary;

  RetailerContactRequest({
    required this.name,
    this.role = 'other',
    this.mobile,
    this.email,
    this.whatsappNumber,
    this.isPrimary = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role,
    if (mobile != null) 'mobile': mobile,
    if (email != null) 'email': email,
    if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
    'is_primary': isPrimary,
  };
}

class RetailerAddressRequest {
  String addressType;
  String? country;
  String? state;
  String? district;
  String? city;
  String? areaName;
  String? street;
  String? landmark;
  String? postalCode;
  bool isDefault;

  RetailerAddressRequest({
    this.addressType = 'business',
    this.country,
    this.state,
    this.district,
    this.city,
    this.areaName,
    this.street,
    this.landmark,
    this.postalCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'address_type': addressType,
    if (country != null) 'country': country,
    if (state != null) 'state': state,
    if (district != null) 'district': district,
    if (city != null) 'city': city,
    if (areaName != null) 'area_name': areaName,
    if (street != null) 'street': street,
    if (landmark != null) 'landmark': landmark,
    if (postalCode != null) 'postal_code': postalCode,
    'is_default': isDefault,
  };
}

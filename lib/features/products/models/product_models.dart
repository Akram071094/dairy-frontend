enum EntityStatus { active, inactive, archived, draft }

extension EntityStatusExtension on EntityStatus {
  String get value {
    switch (this) {
      case EntityStatus.active:
        return 'active';
      case EntityStatus.inactive:
        return 'inactive';
      case EntityStatus.archived:
        return 'archived';
      case EntityStatus.draft:
        return 'draft';
    }
  }

  static EntityStatus fromString(String value) {
    switch (value) {
      case 'active':
        return EntityStatus.active;
      case 'inactive':
        return EntityStatus.inactive;
      case 'archived':
        return EntityStatus.archived;
      case 'draft':
        return EntityStatus.draft;
      default:
        return EntityStatus.draft;
    }
  }
}

class ProductFamily {
  final String id;
  final String businessCode;
  final String name;
  final String? description;
  final ProductCategory? category;
  final EntityStatus status;
  final int skuCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductFamily({
    required this.id,
    required this.businessCode,
    required this.name,
    this.description,
    this.category,
    this.status = EntityStatus.draft,
    this.skuCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductFamily.fromJson(Map<String, dynamic> json) {
    return ProductFamily(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      status: json['status'] != null
          ? EntityStatusExtension.fromString(json['status'])
          : EntityStatus.draft,
      skuCount: json['sku_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_code': businessCode,
    'name': name,
    if (description != null) 'description': description,
    if (category != null) 'category': category!.toJson(),
    'status': status.value,
    'sku_count': skuCount,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
  };
}

class ProductSKU {
  final String id;
  final String businessCode;
  final String familyId;
  final String skuName;
  final String displayName;
  final double measurementQuantity;
  final MeasurementUnit? measurementUnit;
  final PackageType? packageType;
  final String? barcode;
  final double sellingPrice;
  final double costPrice;
  final String? taxCategory;
  final bool inventoryTracking;
  final EntityStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductSKU({
    required this.id,
    required this.businessCode,
    required this.familyId,
    required this.skuName,
    required this.displayName,
    this.measurementQuantity = 0,
    this.measurementUnit,
    this.packageType,
    this.barcode,
    this.sellingPrice = 0,
    this.costPrice = 0,
    this.taxCategory,
    this.inventoryTracking = false,
    this.status = EntityStatus.draft,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductSKU.fromJson(Map<String, dynamic> json) {
    return ProductSKU(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? '',
      familyId: json['family_id']?.toString() ?? '',
      skuName: json['sku_name'] ?? '',
      displayName: json['display_name'] ?? '',
      measurementQuantity: (json['measurement_quantity'] ?? 0).toDouble(),
      measurementUnit: json['measurement_unit'] != null
          ? MeasurementUnit.fromJson(json['measurement_unit'])
          : null,
      packageType: json['package_type'] != null
          ? PackageType.fromJson(json['package_type'])
          : null,
      barcode: json['barcode'],
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      costPrice: (json['cost_price'] ?? 0).toDouble(),
      taxCategory: json['tax_category'],
      inventoryTracking: json['inventory_tracking'] ?? false,
      status: json['status'] != null
          ? EntityStatusExtension.fromString(json['status'])
          : EntityStatus.draft,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_code': businessCode,
    'family_id': familyId,
    'sku_name': skuName,
    'display_name': displayName,
    'measurement_quantity': measurementQuantity,
    if (measurementUnit != null) 'measurement_unit': measurementUnit!.toJson(),
    if (packageType != null) 'package_type': packageType!.toJson(),
    if (barcode != null) 'barcode': barcode,
    'selling_price': sellingPrice,
    'cost_price': costPrice,
    if (taxCategory != null) 'tax_category': taxCategory,
    'inventory_tracking': inventoryTracking,
    'status': status.value,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
  };
}

class MeasurementUnit {
  final String id;
  final String businessCode;
  final String code;
  final String name;
  final String? symbol;
  final String? category;
  final bool isActive;

  MeasurementUnit({
    required this.id,
    required this.businessCode,
    required this.code,
    required this.name,
    this.symbol,
    this.category,
    this.isActive = true,
  });

  factory MeasurementUnit.fromJson(Map<String, dynamic> json) {
    return MeasurementUnit(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'],
      category: json['category'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_code': businessCode,
    'code': code,
    'name': name,
    if (symbol != null) 'symbol': symbol,
    if (category != null) 'category': category,
    'is_active': isActive,
  };
}

class PackageType {
  final String id;
  final String businessCode;
  final String code;
  final String name;
  final int? displayOrder;
  final bool isActive;

  PackageType({
    required this.id,
    required this.businessCode,
    required this.code,
    required this.name,
    this.displayOrder,
    this.isActive = true,
  });

  factory PackageType.fromJson(Map<String, dynamic> json) {
    return PackageType(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      displayOrder: json['display_order'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_code': businessCode,
    'code': code,
    'name': name,
    if (displayOrder != null) 'display_order': displayOrder,
    'is_active': isActive,
  };
}

class ProductCategory {
  final String id;
  final String businessCode;
  final String code;
  final String name;
  final String? description;
  final String? parentId;
  final int? displayOrder;
  final bool isActive;

  ProductCategory({
    required this.id,
    required this.businessCode,
    required this.code,
    required this.name,
    this.description,
    this.parentId,
    this.displayOrder,
    this.isActive = true,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      parentId: json['parent_id']?.toString(),
      displayOrder: json['display_order'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_code': businessCode,
    'code': code,
    'name': name,
    if (description != null) 'description': description,
    if (parentId != null) 'parent_id': parentId,
    if (displayOrder != null) 'display_order': displayOrder,
    'is_active': isActive,
  };
}

class Pricing {
  final String id;
  final String skuId;
  final String priceType;
  final double price;
  final String currency;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final EntityStatus status;

  Pricing({
    required this.id,
    required this.skuId,
    required this.priceType,
    required this.price,
    this.currency = 'INR',
    this.effectiveFrom,
    this.effectiveTo,
    this.status = EntityStatus.active,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json['id']?.toString() ?? '',
      skuId: json['sku_id']?.toString() ?? '',
      priceType: json['price_type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'INR',
      effectiveFrom: json['effective_from'] != null
          ? DateTime.parse(json['effective_from'])
          : null,
      effectiveTo: json['effective_to'] != null
          ? DateTime.parse(json['effective_to'])
          : null,
      status: json['status'] != null
          ? EntityStatusExtension.fromString(json['status'])
          : EntityStatus.active,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku_id': skuId,
    'price_type': priceType,
    'price': price,
    'currency': currency,
    if (effectiveFrom != null) 'effective_from': effectiveFrom!.toIso8601String(),
    if (effectiveTo != null) 'effective_to': effectiveTo!.toIso8601String(),
    'status': status.value,
  };
}

class ProductFamilyCreateRequest {
  String businessCode;
  String name;
  String? description;
  String? categoryId;

  ProductFamilyCreateRequest({
    required this.businessCode,
    required this.name,
    this.description,
    this.categoryId,
  });

  Map<String, dynamic> toJson() => {
    'business_code': businessCode,
    'name': name,
    if (description != null) 'description': description,
    if (categoryId != null) 'category_id': categoryId,
  };
}

class ProductSKUCreateRequest {
  String businessCode;
  String familyId;
  String skuName;
  String displayName;
  double measurementQuantity;
  String? measurementUnitId;
  String? packageTypeId;
  String? barcode;
  double sellingPrice;
  double costPrice;
  String? taxCategory;
  bool inventoryTracking;

  ProductSKUCreateRequest({
    required this.businessCode,
    required this.familyId,
    required this.skuName,
    required this.displayName,
    this.measurementQuantity = 0,
    this.measurementUnitId,
    this.packageTypeId,
    this.barcode,
    this.sellingPrice = 0,
    this.costPrice = 0,
    this.taxCategory,
    this.inventoryTracking = false,
  });

  Map<String, dynamic> toJson() => {
    'business_code': businessCode,
    'family_id': familyId,
    'sku_name': skuName,
    'display_name': displayName,
    'measurement_quantity': measurementQuantity,
    if (measurementUnitId != null) 'measurement_unit_id': measurementUnitId,
    if (packageTypeId != null) 'package_type_id': packageTypeId,
    if (barcode != null) 'barcode': barcode,
    'selling_price': sellingPrice,
    'cost_price': costPrice,
    if (taxCategory != null) 'tax_category': taxCategory,
    'inventory_tracking': inventoryTracking,
  };
}

class MeasurementUnitCreateRequest {
  String businessCode;
  String code;
  String name;
  String? symbol;
  String? category;

  MeasurementUnitCreateRequest({
    required this.businessCode,
    required this.code,
    required this.name,
    this.symbol,
    this.category,
  });

  Map<String, dynamic> toJson() => {
    'business_code': businessCode,
    'code': code,
    'name': name,
    if (symbol != null) 'symbol': symbol,
    if (category != null) 'category': category,
  };
}

class PackageTypeCreateRequest {
  String businessCode;
  String code;
  String name;
  int? displayOrder;

  PackageTypeCreateRequest({
    required this.businessCode,
    required this.code,
    required this.name,
    this.displayOrder,
  });

  Map<String, dynamic> toJson() => {
    'business_code': businessCode,
    'code': code,
    'name': name,
    if (displayOrder != null) 'display_order': displayOrder,
  };
}

class ProductCategoryCreateRequest {
  String businessCode;
  String code;
  String name;
  String? description;
  String? parentId;
  int? displayOrder;

  ProductCategoryCreateRequest({
    required this.businessCode,
    required this.code,
    required this.name,
    this.description,
    this.parentId,
    this.displayOrder,
  });

  Map<String, dynamic> toJson() => {
    'business_code': businessCode,
    'code': code,
    'name': name,
    if (description != null) 'description': description,
    if (parentId != null) 'parent_id': parentId,
    if (displayOrder != null) 'display_order': displayOrder,
  };
}

class PricingUpdateRequest {
  String? priceType;
  double? price;
  String? currency;
  DateTime? effectiveFrom;
  DateTime? effectiveTo;
  String? status;

  PricingUpdateRequest({
    this.priceType,
    this.price,
    this.currency,
    this.effectiveFrom,
    this.effectiveTo,
    this.status,
  });

  Map<String, dynamic> toJson() => {
    if (priceType != null) 'price_type': priceType,
    if (price != null) 'price': price,
    if (currency != null) 'currency': currency,
    if (effectiveFrom != null) 'effective_from': effectiveFrom!.toIso8601String(),
    if (effectiveTo != null) 'effective_to': effectiveTo!.toIso8601String(),
    if (status != null) 'status': status,
  };
}

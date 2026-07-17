class OrganizationModel {
  final String id;
  final String businessCode;
  final String displayName;
  final String? legalName;
  final String? gstNumber;
  final String? fssaiLicenseNumber;
  final String? businessType;
  final String? primaryContactName;
  final String? primaryContactEmail;
  final String? primaryContactPhone;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final String? postalCode;
  final String status;
  final String timezone;
  final String currency;
  final String language;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrganizationModel({
    required this.id,
    required this.businessCode,
    required this.displayName,
    this.legalName,
    this.gstNumber,
    this.fssaiLicenseNumber,
    this.businessType,
    this.primaryContactName,
    this.primaryContactEmail,
    this.primaryContactPhone,
    this.country,
    this.state,
    this.city,
    this.address,
    this.postalCode,
    this.status = 'pending',
    this.timezone = 'UTC',
    this.currency = 'USD',
    this.language = 'en',
    this.createdBy = '',
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id']?.toString() ?? '',
      businessCode: json['business_code'] ?? json['org_code'] ?? '',
      displayName: json['display_name'] ?? json['org_name'] ?? '',
      legalName: json['legal_name'],
      gstNumber: json['gst_number'],
      fssaiLicenseNumber: json['fssai_license_number'],
      businessType: json['business_type'],
      primaryContactName: json['primary_contact_name'],
      primaryContactEmail: json['primary_contact_email'],
      primaryContactPhone: json['primary_contact_phone'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      address: json['address'],
      postalCode: json['postal_code'],
      status: json['status'] ?? 'pending',
      timezone: json['timezone'] ?? 'UTC',
      currency: json['currency'] ?? 'USD',
      language: json['language'] ?? 'en',
      createdBy: json['created_by']?.toString() ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}

class BusinessProfileModel {
  final String id;
  final String organizationId;
  final String? registrationNumber;
  final String? taxId;
  final String? industryClassification;
  final int? yearEstablished;
  final int? employeeCount;
  final double? annualRevenue;
  final String? websiteUrl;

  BusinessProfileModel({
    required this.id,
    required this.organizationId,
    this.registrationNumber,
    this.taxId,
    this.industryClassification,
    this.yearEstablished,
    this.employeeCount,
    this.annualRevenue,
    this.websiteUrl,
  });

  factory BusinessProfileModel.fromJson(Map<String, dynamic> json) {
    return BusinessProfileModel(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      registrationNumber: json['registration_number'] ?? json['business_registration_number'],
      taxId: json['tax_identification_number'],
      industryClassification: json['industry_classification'] ?? json['industry'],
      yearEstablished: json['year_established'],
      employeeCount: json['employee_count'] ?? json['employee_count_range'],
      annualRevenue: (json['annual_revenue'] ?? json['annual_revenue_range'])?.toDouble(),
      websiteUrl: json['website_url'] ?? json['website'],
    );
  }
}

class BrandingModel {
  final String id;
  final String organizationId;
  final String? primaryColor;
  final String? secondaryColor;
  final String? logoUrl;
  final String? faviconUrl;

  BrandingModel({
    required this.id,
    required this.organizationId,
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
    this.faviconUrl,
  });

  factory BrandingModel.fromJson(Map<String, dynamic> json) {
    return BrandingModel(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      primaryColor: json['primary_color'],
      secondaryColor: json['secondary_color'],
      logoUrl: json['logo_url'],
      faviconUrl: json['favicon_url'],
    );
  }
}

class PreferencesModel {
  final String id;
  final String organizationId;
  final List<String>? workingDays;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final int? fiscalYearStartMonth;
  final int? defaultCreditDays;
  final String? invoicePrefix;

  PreferencesModel({
    required this.id,
    required this.organizationId,
    this.workingDays,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.fiscalYearStartMonth,
    this.defaultCreditDays,
    this.invoicePrefix,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      workingDays: json['working_days'] != null ? List<String>.from(json['working_days']) : null,
      workingHoursStart: json['working_hours_start'],
      workingHoursEnd: json['working_hours_end'],
      fiscalYearStartMonth: json['financial_year_start_month'] ?? json['fiscal_year_start'],
      defaultCreditDays: json['default_credit_days'] ?? json['default_payment_terms'],
      invoicePrefix: json['invoice_prefix'],
    );
  }
}

class OrganizationCreateRequest {
  String businessCode;
  String displayName;
  String? legalName;
  String? gstNumber;
  String? fssaiLicenseNumber;
  String? businessType;
  String? primaryContactName;
  String? primaryContactEmail;
  String? primaryContactPhone;
  String? country;
  String? state;
  String? city;
  String? address;
  String? postalCode;
  String timezone;
  String currency;
  String language;

  OrganizationCreateRequest({
    required this.businessCode,
    required this.displayName,
    this.legalName,
    this.gstNumber,
    this.fssaiLicenseNumber,
    this.businessType,
    this.primaryContactName,
    this.primaryContactEmail,
    this.primaryContactPhone,
    this.country,
    this.state,
    this.city,
    this.address,
    this.postalCode,
    this.timezone = 'UTC',
    this.currency = 'USD',
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
    'business_code': businessCode,
    'display_name': displayName,
    if (legalName != null) 'legal_name': legalName,
    if (gstNumber != null) 'gst_number': gstNumber,
    if (fssaiLicenseNumber != null) 'fssai_license_number': fssaiLicenseNumber,
    if (businessType != null) 'business_type': businessType,
    if (primaryContactName != null) 'primary_contact_name': primaryContactName,
    if (primaryContactEmail != null) 'primary_contact_email': primaryContactEmail,
    if (primaryContactPhone != null) 'primary_contact_phone': primaryContactPhone,
    if (country != null) 'country': country,
    if (state != null) 'state': state,
    if (city != null) 'city': city,
    if (address != null) 'address': address,
    if (postalCode != null) 'postal_code': postalCode,
    'timezone': timezone,
    'currency': currency,
    'language': language,
  };
}

class BusinessProfileRequest {
  String? registrationNumber;
  String? taxId;
  String? industryClassification;
  int? yearEstablished;
  int? employeeCount;
  double? annualRevenue;
  String? websiteUrl;

  BusinessProfileRequest({
    this.registrationNumber,
    this.taxId,
    this.industryClassification,
    this.yearEstablished,
    this.employeeCount,
    this.annualRevenue,
    this.websiteUrl,
  });

  Map<String, dynamic> toJson() => {
    if (registrationNumber != null) 'registration_number': registrationNumber,
    if (taxId != null) 'tax_identification_number': taxId,
    if (industryClassification != null) 'industry_classification': industryClassification,
    if (yearEstablished != null) 'year_established': yearEstablished,
    if (employeeCount != null) 'employee_count': employeeCount,
    if (annualRevenue != null) 'annual_revenue': annualRevenue,
    if (websiteUrl != null) 'website_url': websiteUrl,
  };
}

class BrandingRequest {
  String? primaryColor;
  String? secondaryColor;
  String? logoUrl;
  String? faviconUrl;

  BrandingRequest({
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
    this.faviconUrl,
  });

  Map<String, dynamic> toJson() => {
    if (primaryColor != null) 'primary_color': primaryColor,
    if (secondaryColor != null) 'secondary_color': secondaryColor,
    if (logoUrl != null) 'logo_url': logoUrl,
    if (faviconUrl != null) 'favicon_url': faviconUrl,
  };
}

class PreferencesRequest {
  List<String>? workingDays;
  String? workingHoursStart;
  String? workingHoursEnd;
  int? fiscalYearStartMonth;
  int? defaultCreditDays;
  String? invoicePrefix;

  PreferencesRequest({
    this.workingDays,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.fiscalYearStartMonth,
    this.defaultCreditDays,
    this.invoicePrefix,
  });

  Map<String, dynamic> toJson() => {
    if (workingDays != null) 'working_days': workingDays,
    if (workingHoursStart != null) 'working_hours_start': workingHoursStart,
    if (workingHoursEnd != null) 'working_hours_end': workingHoursEnd,
    if (fiscalYearStartMonth != null) 'financial_year_start_month': fiscalYearStartMonth,
    if (defaultCreditDays != null) 'default_credit_days': defaultCreditDays,
    if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
  };
}

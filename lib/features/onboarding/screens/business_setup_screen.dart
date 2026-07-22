import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/constants/ui_constants.dart';
import 'package:dairy_frontend/core/router/app_router.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/core/utils/validators.dart';
import 'package:dairy_frontend/features/onboarding/models/organization_model.dart';
import 'package:dairy_frontend/features/onboarding/providers/onboarding_provider.dart';
import 'package:dairy_frontend/features/onboarding/widgets/step_form.dart';

class BusinessSetupScreen extends StatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessCodeController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _legalNameController = TextEditingController();
  final _gstController = TextEditingController();
  final _fssaiController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();

  String? _businessType;
  String? _country;
  String? _state;
  String _timezone = 'UTC';
  String _currency = 'USD';
  String _language = 'en';

  final _businessTypes = [
    'Private Limited',
    'Public Limited',
    'Partnership',
    'Sole Proprietorship',
    'LLP',
    'Non-Profit',
    'Cooperative',
    'Other',
  ];

  final _countries = ['India', 'United States', 'United Kingdom', 'Canada', 'Australia', 'Other'];
  final _timezones = ['UTC', 'Asia/Kolkata', 'America/New_York', 'Europe/London', 'Asia/Dubai'];
  final _currencies = ['USD', 'INR', 'GBP', 'EUR', 'CAD', 'AUD'];
  final _languages = ['en', 'hi', 'es', 'fr', 'ar'];

  final _stateControllers = <String, List<String>>{
    'India': [
      'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa',
      'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala',
      'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland',
      'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
      'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    ],
    'United States': [
      'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
      'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
      'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
      'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi',
      'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
      'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma',
      'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
      'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
      'West Virginia', 'Wisconsin', 'Wyoming',
    ],
  };

  @override
  void dispose() {
    _businessCodeController.dispose();
    _displayNameController.dispose();
    _legalNameController.dispose();
    _gstController.dispose();
    _fssaiController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<OnboardingProvider>();
    final request = OrganizationCreateRequest(
      businessCode: _businessCodeController.text.trim().toUpperCase(),
      displayName: _displayNameController.text.trim(),
      legalName: _legalNameController.text.trim().isEmpty ? null : _legalNameController.text.trim(),
      gstNumber: _gstController.text.trim().isEmpty ? null : _gstController.text.trim(),
      fssaiLicenseNumber: _fssaiController.text.trim().isEmpty ? null : _fssaiController.text.trim(),
      businessType: _businessType,
      primaryContactName: _contactNameController.text.trim().isEmpty ? null : _contactNameController.text.trim(),
      primaryContactEmail: _contactEmailController.text.trim().isEmpty ? null : _contactEmailController.text.trim(),
      primaryContactPhone: _contactPhoneController.text.trim().isEmpty ? null : _contactPhoneController.text.trim(),
      country: _country,
      state: _state,
      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      postalCode: _postalCodeController.text.trim().isEmpty ? null : _postalCodeController.text.trim(),
      timezone: _timezone,
      currency: _currency,
      language: _language,
    );
    try {
      final orgId = await provider.createOrg(request);
      if (mounted) context.go(AppRouter.actionCenter);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create business: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _onSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingSkippedKey, true);
    if (mounted) context.go(AppRouter.actionCenter);
  }

  InputDecoration _inputDecoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surfaceDim,
      border: OutlineInputBorder(
        borderRadius: AppDimensions.radiusSm,
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDimensions.radiusSm,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDimensions.radiusSm,
        borderSide: BorderSide(color: AppColors.borderFocus),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppDimensions.radiusSm,
        borderSide: BorderSide(color: AppColors.borderError),
      ),
      contentPadding: AppDimensions.fieldPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return StepForm(
      prompt: "Let's start with the basics! I'll help you register your business in no time.",
      stepNumber: 1,
      totalSteps: 1,
      isPrimaryLoading: provider.isLoading,
      primaryLabel: 'Create Business',
      onPrimaryTap: _onSubmit,
      showSecondary: false,
      formContent: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Identity', style: AppTypography.h3),
            const SizedBox(height: 16),
            TextFormField(
              controller: _businessCodeController,
              decoration: _inputDecoration('Business Code', hint: 'e.g. DAIRY001'),
              textCapitalization: TextCapitalization.characters,
              validator: Validators.businessCode,
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _displayNameController,
              decoration: _inputDecoration('Display Name', hint: 'Your business name'),
              validator: (v) => Validators.required(v, 'Display name'),
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _legalNameController,
              decoration: _inputDecoration('Legal Name (optional)', hint: 'Registered legal name'),
            ),
            const SizedBox(height: 24),
            Text('Business Type', style: AppTypography.h3),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _businessType,
              decoration: _inputDecoration('Business Type'),
              items: _businessTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _businessType = v),
            ),
            const SizedBox(height: 24),
            Text('Registration Details', style: AppTypography.h3),
            const SizedBox(height: 16),
            TextFormField(
              controller: _gstController,
              decoration: _inputDecoration('GST Number (optional)'),
              validator: Validators.gst,
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _fssaiController,
              decoration: _inputDecoration('FSSAI License Number (optional)'),
            ),
            const SizedBox(height: 24),
            Text('Contact Information', style: AppTypography.h3),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactNameController,
              decoration: _inputDecoration('Primary Contact Name (optional)'),
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _contactEmailController,
              decoration: _inputDecoration('Primary Contact Email (optional)'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v != null && v.isNotEmpty ? Validators.email(v) : null,
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _contactPhoneController,
              decoration: _inputDecoration('Primary Contact Phone (optional)'),
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 24),
            Text('Address', style: AppTypography.h3),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _country,
              decoration: _inputDecoration('Country'),
              items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() {
                _country = v;
                _state = null;
              }),
            ),
            const SizedBox(height: UiConstants.md),
            if (_country != null && _stateControllers.containsKey(_country!))
              DropdownButtonFormField<String>(
                value: _state,
                decoration: _inputDecoration('State'),
                items: _stateControllers[_country!]!
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _state = v),
              ),
            if (_country != null && !_stateControllers.containsKey(_country!))
              TextFormField(
                controller: _cityController..text = _state ?? '',
                decoration: _inputDecoration('State'),
                onChanged: (v) => _state = v,
              ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _cityController,
              decoration: _inputDecoration('City (optional)'),
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _addressController,
              decoration: _inputDecoration('Address (optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _postalCodeController,
              decoration: _inputDecoration('Postal Code (optional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Text('Configuration', style: AppTypography.h3),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _timezone,
              decoration: _inputDecoration('Timezone'),
              items: _timezones.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _timezone = v ?? 'UTC'),
            ),
            const SizedBox(height: UiConstants.md),
            DropdownButtonFormField<String>(
              value: _currency,
              decoration: _inputDecoration('Currency'),
              items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _currency = v ?? 'USD'),
            ),
            const SizedBox(height: UiConstants.md),
            DropdownButtonFormField<String>(
              value: _language,
              decoration: _inputDecoration('Language'),
              items: _languages.map((l) {
                final label = {'en': 'English', 'hi': 'Hindi', 'es': 'Spanish', 'fr': 'French', 'ar': 'Arabic'}[l] ?? l;
                return DropdownMenuItem(value: l, child: Text(label));
              }).toList(),
              onChanged: (v) => setState(() => _language = v ?? 'en'),
            ),
          ],
        ),
      ),
    );
  }
}

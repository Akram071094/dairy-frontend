import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/constants/ui_constants.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/core/utils/validators.dart';
import 'package:dairy_frontend/features/onboarding/models/organization_model.dart';
import 'package:dairy_frontend/features/onboarding/providers/onboarding_provider.dart';
import 'package:dairy_frontend/features/onboarding/widgets/step_form.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registrationNumberController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _yearController = TextEditingController();
  final _employeeCountController = TextEditingController();
  final _revenueController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _industryClassification;

  final _industries = [
    'Dairy Farming',
    'Dairy Processing',
    'Milk Distribution',
    'Food & Beverage',
    'Agriculture',
    'Logistics & Supply Chain',
    'Retail',
    'Wholesale',
    'Other',
  ];

  @override
  void dispose() {
    _registrationNumberController.dispose();
    _taxIdController.dispose();
    _yearController.dispose();
    _employeeCountController.dispose();
    _revenueController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<OnboardingProvider>();
    final orgId = provider.organization?.id;
    if (orgId == null || orgId.isEmpty) return;
    final request = BusinessProfileRequest(
      registrationNumber: _registrationNumberController.text.trim().isEmpty
          ? null : _registrationNumberController.text.trim(),
      taxId: _taxIdController.text.trim().isEmpty ? null : _taxIdController.text.trim(),
      industryClassification: _industryClassification,
      yearEstablished: _yearController.text.trim().isEmpty
          ? null : int.tryParse(_yearController.text.trim()),
      employeeCount: _employeeCountController.text.trim().isEmpty
          ? null : int.tryParse(_employeeCountController.text.trim()),
      annualRevenue: _revenueController.text.trim().isEmpty
          ? null : double.tryParse(_revenueController.text.trim()),
      websiteUrl: _websiteController.text.trim().isEmpty
          ? null : _websiteController.text.trim(),
    );
    await provider.saveProfile(orgId, request);
    if (mounted) context.pop();
  }

  Future<void> _onSkip() async {
    if (mounted) context.pop();
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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
      prompt: "Tell me more about your business! These details help us tailor the experience for you.",
      stepNumber: 2,
      totalSteps: 5,
      isPrimaryLoading: provider.isLoading,
      primaryLabel: 'Save Profile',
      onPrimaryTap: _onSubmit,
      secondaryLabel: 'Skip for now',
      onSecondaryTap: _onSkip,
      formContent: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Registration', style: AppTypography.h3),
            const SizedBox(height: 16),
            TextFormField(
              controller: _registrationNumberController,
              decoration: _inputDecoration('Registration Number (optional)'),
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _taxIdController,
              decoration: _inputDecoration('Tax ID (optional)'),
            ),
            const SizedBox(height: 24),
            Text('Classification', style: AppTypography.h3),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _industryClassification,
              decoration: _inputDecoration('Industry Classification'),
              items: _industries.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: (v) => setState(() => _industryClassification = v),
            ),
            const SizedBox(height: 24),
            Text('Business Scale', style: AppTypography.h3),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearController,
              decoration: _inputDecoration('Year Established (optional)'),
              keyboardType: TextInputType.number,
              validator: Validators.yearEstablished,
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _employeeCountController,
              decoration: _inputDecoration('Employee Count (optional)'),
              keyboardType: TextInputType.number,
              validator: (v) => Validators.numeric(v, 'Employee count'),
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _revenueController,
              decoration: _inputDecoration('Annual Revenue (optional)'),
              keyboardType: TextInputType.number,
              validator: (v) => Validators.numeric(v, 'Annual revenue'),
            ),
            const SizedBox(height: 24),
            Text('Online Presence', style: AppTypography.h3),
            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: _inputDecoration('Website URL (optional)'),
              keyboardType: TextInputType.url,
              validator: Validators.url,
            ),
          ],
        ),
      ),
    );
  }
}

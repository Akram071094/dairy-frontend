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
import 'package:dairy_frontend/features/onboarding/models/organization_model.dart';
import 'package:dairy_frontend/features/onboarding/providers/onboarding_provider.dart';
import 'package:dairy_frontend/features/onboarding/widgets/step_form.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _creditDaysController = TextEditingController();
  final _invoicePrefixController = TextEditingController();

  final _allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final _fullDayNames = {
    'Mon': 'Monday', 'Tue': 'Tuesday', 'Wed': 'Wednesday',
    'Thu': 'Thursday', 'Fri': 'Friday', 'Sat': 'Saturday', 'Sun': 'Sunday',
  };
  Set<String> _selectedDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  int? _fiscalYearStartMonth;

  @override
  void dispose() {
    _creditDaysController.dispose();
    _invoicePrefixController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked;
        else _endTime = picked;
      });
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<OnboardingProvider>();
    final orgId = provider.organization?.id;
    if (orgId == null || orgId.isEmpty) return;
    final request = PreferencesRequest(
      workingDays: _selectedDays.toList(),
      workingHoursStart: '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
      workingHoursEnd: '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
      fiscalYearStartMonth: _fiscalYearStartMonth,
      defaultCreditDays: _creditDaysController.text.trim().isEmpty
          ? null : int.tryParse(_creditDaysController.text.trim()),
      invoicePrefix: _invoicePrefixController.text.trim().isEmpty
          ? null : _invoicePrefixController.text.trim(),
    );
    await provider.savePreferences(orgId, request);
    if (mounted) context.pop();
  }

  Future<void> _onSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingSkippedKey, true);
    if (mounted) context.go(AppRouter.actionCenter);
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

  String _timeDisplay(TimeOfDay t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return StepForm(
      prompt: "Let's configure your business preferences. Set your working days, hours, and other defaults.",
      stepNumber: 4,
      totalSteps: 5,
      isPrimaryLoading: provider.isLoading,
      primaryLabel: 'Save Preferences',
      onPrimaryTap: _onSubmit,
      showSecondary: false,
      formContent: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Working Days', style: AppTypography.h3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allDays.map((day) {
                final selected = _selectedDays.contains(day);
                return FilterChip(
                  label: Text(_fullDayNames[day]!),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) _selectedDays.add(day);
                      else _selectedDays.remove(day);
                    });
                  },
                  selectedColor: AppColors.primaryLight,
                  checkmarkColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceDim,
                  side: BorderSide(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusSm),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Working Hours', style: AppTypography.h3),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTime(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDim,
                        borderRadius: AppDimensions.radiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Start: ${_timeDisplay(_startTime)}', style: AppTypography.body),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTime(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDim,
                        borderRadius: AppDimensions.radiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('End: ${_timeDisplay(_endTime)}', style: AppTypography.body),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Fiscal Year', style: AppTypography.h3),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _fiscalYearStartMonth,
              decoration: _inputDecoration('Fiscal Year Start Month'),
              items: List.generate(12, (i) {
                final month = i + 1;
                final names = [
                  'January', 'February', 'March', 'April', 'May', 'June',
                  'July', 'August', 'September', 'October', 'November', 'December'
                ];
                return DropdownMenuItem(value: month, child: Text(names[i]));
              }),
              onChanged: (v) => setState(() => _fiscalYearStartMonth = v),
            ),
            const SizedBox(height: 24),
            Text('Defaults', style: AppTypography.h3),
            const SizedBox(height: 12),
            TextFormField(
              controller: _creditDaysController,
              decoration: _inputDecoration('Default Credit Days (optional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: UiConstants.md),
            TextFormField(
              controller: _invoicePrefixController,
              decoration: _inputDecoration('Invoice Prefix (optional)', hint: 'e.g. INV-'),
            ),
          ],
        ),
      ),
    );
  }
}

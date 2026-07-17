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

class BrandingScreen extends StatefulWidget {
  const BrandingScreen({super.key});

  @override
  State<BrandingScreen> createState() => _BrandingScreenState();
}

class _BrandingScreenState extends State<BrandingScreen> {
  Color _primaryColor = AppColors.primary;
  Color _secondaryColor = AppColors.secondary;
  bool _showPrimaryPicker = false;
  bool _showSecondaryPicker = false;

  static const List<Color> _presetColors = [
    Color(0xFF0E7C66),
    Color(0xFF5BA82E),
    Color(0xFF2563EB),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFFF43F5E),
    Color(0xFFF97316),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF06B6D4),
    Color(0xFF6366F1),
    Color(0xFF78716C),
    Color(0xFF1C1917),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF0A5A4A),
  ];

  Future<void> _onSubmit() async {
    final provider = context.read<OnboardingProvider>();
    final orgId = provider.organization?.id;
    if (orgId == null || orgId.isEmpty) return;
    final request = BrandingRequest(
      primaryColor: '#${_primaryColor.value.toRadixString(16).substring(2).toUpperCase()}',
      secondaryColor: '#${_secondaryColor.value.toRadixString(16).substring(2).toUpperCase()}',
    );
    await provider.saveBranding(orgId, request);
    if (mounted) context.pop();
  }

  Future<void> _onSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingSkippedKey, true);
    if (mounted) context.go(AppRouter.actionCenter);
  }

  Widget _buildColorPickerSection({
    required String label,
    required Color currentColor,
    required bool isOpen,
    required ValueChanged<Color> onColorChanged,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppDimensions.radiusSm,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: currentColor,
                    borderRadius: AppDimensions.radiusSm,
                    border: Border.all(color: AppColors.border),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: AppTypography.body)),
                Icon(isOpen ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
        if (isOpen) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: AppDimensions.radiusSm,
              border: Border.all(color: AppColors.border),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetColors.map((color) {
                final isSelected = color.value == currentColor.value;
                return GestureDetector(
                  onTap: () => onColorChanged(color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: AppDimensions.radiusSm,
                      border: Border.all(
                        color: isSelected ? AppColors.text : AppColors.border,
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return StepForm(
      prompt: "Let's make it look great! Choose your brand colors.",
      stepNumber: 3,
      totalSteps: 5,
      isPrimaryLoading: provider.isLoading,
      primaryLabel: 'Save Branding',
      onPrimaryTap: _onSubmit,
      showSecondary: false,
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Brand Colors', style: AppTypography.h3),
          const SizedBox(height: 16),
          _buildColorPickerSection(
            label: 'Primary Color',
            currentColor: _primaryColor,
            isOpen: _showPrimaryPicker,
            onColorChanged: (c) => setState(() => _primaryColor = c),
            onToggle: () => setState(() {
              _showPrimaryPicker = !_showPrimaryPicker;
              _showSecondaryPicker = false;
            }),
          ),
          const SizedBox(height: UiConstants.md),
          _buildColorPickerSection(
            label: 'Secondary Color',
            currentColor: _secondaryColor,
            isOpen: _showSecondaryPicker,
            onColorChanged: (c) => setState(() => _secondaryColor = c),
            onToggle: () => setState(() {
              _showSecondaryPicker = !_showSecondaryPicker;
              _showPrimaryPicker = false;
            }),
          ),
          const SizedBox(height: 24),
          Text('Preview', style: AppTypography.h3),
          const SizedBox(height: 16),
          _buildPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: AppDimensions.radiusMd,
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _secondaryColor,
              borderRadius: AppDimensions.radiusSm,
            ),
            child: Center(
              child: Text(
                'Z',
                style: AppTypography.h2.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Brand Preview',
            style: AppTypography.h3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Your brand colors in action',
            style: AppTypography.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

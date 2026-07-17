import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dairy_frontend/core/constants/ui_constants.dart';
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
  String? _logoPath;
  String? _faviconPath;
  bool _showPrimaryPicker = false;
  bool _showSecondaryPicker = false;

  final _picker = ImagePicker();

  Future<void> _pickImage(bool isLogo) async {
    final file = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
    if (file != null) {
      setState(() {
        if (isLogo) {
          _logoPath = file.path;
        } else {
          _faviconPath = file.path;
        }
      });
    }
  }

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
    if (mounted) context.pop();
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: AppDimensions.radiusSm,
              border: Border.all(color: AppColors.border),
            ),
            child: BlockPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              availableColors: [
                AppColors.primary,
                AppColors.secondary,
                const Color(0xFF8B5CF6),
                const Color(0xFFEC4899),
                const Color(0xFFF43F5E),
                const Color(0xFFF97316),
                const Color(0xFFF59E0B),
                const Color(0xFF10B981),
                const Color(0xFF06B6D4),
                const Color(0xFF6366F1),
                const Color(0xFF78716C),
                const Color(0xFF1C1917),
              ],
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
      prompt: "Let's make it look great! Choose your brand colors and upload your logo.",
      stepNumber: 3,
      totalSteps: 5,
      isPrimaryLoading: provider.isLoading,
      primaryLabel: 'Save Branding',
      onPrimaryTap: _onSubmit,
      secondaryLabel: 'Skip for now',
      onSecondaryTap: _onSkip,
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
          Text('Logo', style: AppTypography.h3),
          const SizedBox(height: 16),
          _buildImagePickerCard(
            label: 'Upload Logo',
            filePath: _logoPath,
            onTap: () => _pickImage(true),
            onClear: _logoPath != null ? () => setState(() => _logoPath = null) : null,
          ),
          const SizedBox(height: UiConstants.md),
          Text('Favicon', style: AppTypography.h3),
          const SizedBox(height: 16),
          _buildImagePickerCard(
            label: 'Upload Favicon',
            filePath: _faviconPath,
            onTap: () => _pickImage(false),
            onClear: _faviconPath != null ? () => setState(() => _faviconPath = null) : null,
          ),
          const SizedBox(height: 24),
          Text('Preview', style: AppTypography.h3),
          const SizedBox(height: 16),
          _buildPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildImagePickerCard({
    required String label,
    required String? filePath,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusSm,
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          if (filePath != null)
            ClipRRect(
              borderRadius: AppDimensions.radiusSm,
              child: Image.file(
                File(filePath),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                borderRadius: AppDimensions.radiusSm,
              ),
              child: const Icon(Icons.image_outlined, color: AppColors.textSecondary),
            ),
          const SizedBox(width: 12),
          Expanded(child: Text(filePath != null ? 'Image selected' : label, style: AppTypography.bodySmall)),
          if (onClear != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClear,
              color: AppColors.textSecondary,
            ),
          TextButton(
            onPressed: onTap,
            child: Text(filePath != null ? 'Change' : 'Browse', style: AppTypography.link),
          ),
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
                'M',
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

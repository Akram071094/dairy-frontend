import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

class ColorPickerCard extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerCard({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  void _showPicker(BuildContext context) {
    Color picked = color;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose $label', style: AppTypography.h3),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: picked,
            onColorChanged: (c) => picked = c,
            availableColors: const [
              Color(0xFF2563EB),
              Color(0xFF0D9488),
              Color(0xFFEF4444),
              Color(0xFFF59E0B),
              Color(0xFF22C55E),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
              Color(0xFF6366F1),
              Color(0xFF14B8A6),
              Color(0xFFF97316),
              Color(0xFF1E293B),
              Color(0xFF64748B),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: AppTypography.bodySmall),
          ),
          ElevatedButton(
            onPressed: () {
              onColorChanged(picked);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusSm),
            ),
            child: const Text('Select', style: AppTypography.button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: AppDimensions.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppDimensions.radiusMd,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
              ),
            ),
            const SizedBox(width: UiConstants.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text(hex, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.colorize, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

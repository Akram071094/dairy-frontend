import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: UiConstants.sm),
            ],
            Text(title, style: AppTypography.h3.copyWith(color: AppColors.text)),
          ],
        ),
        const SizedBox(height: UiConstants.md),
        const Divider(color: AppColors.border, height: 1, thickness: 1),
        const SizedBox(height: UiConstants.md),
      ],
    );
  }
}

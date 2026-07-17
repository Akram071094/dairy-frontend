import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

class SectionDivider extends StatelessWidget {
  final String? label;

  const SectionDivider({
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return const Divider(color: AppColors.border, height: 1, thickness: 1);
    }

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: UiConstants.md),
          child: Text(
            label!,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }
}

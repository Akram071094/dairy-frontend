import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

class ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const ReviewRow({
    super.key,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstants.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body.copyWith(color: AppColors.text),
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Padding(
                padding: const EdgeInsets.only(left: UiConstants.sm),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

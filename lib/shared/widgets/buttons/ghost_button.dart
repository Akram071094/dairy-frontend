import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isActive;
  final Widget? icon;

  const GhostButton({
    super.key,
    required this.label,
    this.onTap,
    this.isActive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? AppColors.primary : AppColors.textSecondary,
        disabledForegroundColor: AppColors.textSecondary.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(width: 6),
          Text(label, style: AppTypography.button.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';

class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  QuickAction({required this.label, required this.icon, this.onTap});
}

class QuickActions extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActions({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((action) {
        return OutlinedButton.icon(
          onPressed: action.onTap,
          icon: Icon(action.icon, size: 18),
          label: Text(action.label, style: AppTypography.bodySmall),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusSm),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        );
      }).toList(),
    );
  }
}

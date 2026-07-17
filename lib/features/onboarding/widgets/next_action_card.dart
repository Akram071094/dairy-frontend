import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/onboarding/models/onboarding_status.dart';

class NextActionCard extends StatelessWidget {
  final OnboardingStatus status;
  final VoidCallback? onTap;

  const NextActionCard({super.key, required this.status, this.onTap});

  IconData _icon() {
    if (status.isComplete) return Icons.celebration;
    if (!status.steps.createOrganization) return Icons.business;
    if (!status.steps.businessProfile) return Icons.assignment;
    if (!status.steps.branding) return Icons.palette;
    if (!status.steps.preferences) return Icons.settings;
    if (!status.steps.activation) return Icons.rocket_launch;
    return Icons.check_circle;
  }

  Color _color() {
    if (status.isComplete) return AppColors.success;
    if (!status.steps.createOrganization) return AppColors.primary;
    if (!status.steps.businessProfile) return AppColors.secondary;
    if (!status.steps.branding) return const Color(0xFF8B5CF6);
    if (!status.steps.preferences) return const Color(0xFFF59E0B);
    if (!status.steps.activation) return AppColors.error;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppDimensions.cardPadding,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppDimensions.radiusMd,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: AppDimensions.radiusSm,
              ),
              child: Icon(_icon(), color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Step',
                    style: AppTypography.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status.nextActionLabel,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/onboarding/models/onboarding_status.dart';

class HeroSection extends StatelessWidget {
  final OnboardingStatus? status;

  const HeroSection({super.key, this.status});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _statusMessage() {
    if (status == null) return "Let's get your business set up!";
    if (status!.isComplete) return 'Your onboarding is complete!';
    final done = status!.completedCount;
    final total = status!.totalSteps;
    if (done == 0) return "Let's get started with your business setup!";
    if (done == total - 1) return 'One last step to go!';
    return 'Great progress! $done of $total steps completed.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimensions.radiusXl,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'M',
                style: AppTypography.h2.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_greeting, ${AppConstants.aiAssistantName}!',
                  style: AppTypography.h3.copyWith(color: AppColors.textOnPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusMessage(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

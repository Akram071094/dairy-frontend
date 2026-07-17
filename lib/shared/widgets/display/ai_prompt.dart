import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';
import 'ai_assistant_avatar.dart';

class AiPrompt extends StatelessWidget {
  final String message;
  final int? stepNumber;
  final int? totalSteps;

  const AiPrompt({
    super.key,
    required this.message,
    this.stepNumber,
    this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AiAssistantAvatar(size: 40, mood: AiMood.smiling),
        const SizedBox(width: UiConstants.sm),
        Expanded(
          child: Container(
            padding: AppDimensions.cardPadding.copyWith(
              top: 12,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppDimensions.radiusLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stepNumber != null && totalSteps != null) ...[
                  Text(
                    'Step $stepNumber of $totalSteps',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message,
                  style: AppTypography.body.copyWith(color: AppColors.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

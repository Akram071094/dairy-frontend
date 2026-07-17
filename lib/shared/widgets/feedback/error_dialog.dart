import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusLg),
      contentPadding: AppDimensions.cardPadding,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 36,
            ),
          ),
          const SizedBox(height: UiConstants.md),
          Text(title, style: AppTypography.h2, textAlign: TextAlign.center),
          const SizedBox(height: UiConstants.sm),
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UiConstants.lg),
          Row(
            children: [
              if (onDismiss != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDismiss!();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusSm),
                      padding: const EdgeInsets.symmetric(vertical: UiConstants.buttonHeight * 0.25),
                    ),
                    child: const Text('Dismiss'),
                  ),
                ),
              if (onDismiss != null && onRetry != null)
                const SizedBox(width: UiConstants.sm),
              if (onRetry != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onRetry!();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusSm),
                      padding: const EdgeInsets.symmetric(vertical: UiConstants.buttonHeight * 0.25),
                      elevation: 0,
                    ),
                    child: const Text('Retry'),
                  ),
                ),
              if (onRetry == null && onDismiss == null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusSm),
                      elevation: 0,
                    ),
                    child: const Text('OK'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

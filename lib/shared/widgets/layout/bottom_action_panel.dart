import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/ui_constants.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

class BottomActionPanel extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimaryTap;
  final bool isPrimaryLoading;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryTap;
  final bool showSecondary;

  const BottomActionPanel({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryTap,
    this.isPrimaryLoading = false,
    this.secondaryLabel,
    this.onSecondaryTap,
    this.showSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.screenPadding.left,
        right: AppDimensions.screenPadding.right,
        top: UiConstants.md,
        bottom: MediaQuery.of(context).padding.bottom + UiConstants.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: primaryLabel,
              onTap: onPrimaryTap,
              isLoading: isPrimaryLoading,
            ),
            if (showSecondary && secondaryLabel != null) ...[
              const SizedBox(height: UiConstants.sm),
              SecondaryButton(
                label: secondaryLabel!,
                onTap: onSecondaryTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

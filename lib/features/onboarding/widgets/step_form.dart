import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/shared/widgets/buttons/primary_button.dart';

class StepForm extends StatelessWidget {
  final String prompt;
  final int stepNumber;
  final int totalSteps;
  final Widget formContent;
  final String primaryLabel;
  final VoidCallback onPrimaryTap;
  final bool isPrimaryLoading;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryTap;
  final bool showSecondary;

  const StepForm({
    super.key,
    required this.prompt,
    required this.stepNumber,
    required this.totalSteps,
    required this.formContent,
    required this.primaryLabel,
    required this.onPrimaryTap,
    this.isPrimaryLoading = false,
    this.secondaryLabel,
    this.onSecondaryTap,
    this.showSecondary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step $stepNumber of $totalSteps'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: AppDimensions.cardPadding,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppDimensions.radiusMd,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      prompt,
                      style: AppTypography.body.copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            formContent,
            const SizedBox(height: 32),
            PrimaryButton(
              label: primaryLabel,
              onTap: onPrimaryTap,
              isLoading: isPrimaryLoading,
            ),
            if (showSecondary && secondaryLabel != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: onSecondaryTap,
                  child: Text(
                    secondaryLabel!,
                    style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

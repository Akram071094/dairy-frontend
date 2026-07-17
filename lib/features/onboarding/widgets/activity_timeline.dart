import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/onboarding/models/onboarding_status.dart';

class ActivityTimeline extends StatelessWidget {
  final OnboardingStatus status;

  const ActivityTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = _steps();
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        return _TimelineStep(
          step: step,
          isLast: isLast,
          index: i,
        );
      }),
    );
  }

  List<_StepData> _steps() {
    return [
      _StepData(
        label: 'Register Business',
        subtitle: 'Create your organization',
        isCompleted: status.steps.createOrganization,
        isCurrent: !status.steps.createOrganization,
      ),
      _StepData(
        label: 'Business Profile',
        subtitle: 'Add your business details',
        isCompleted: status.steps.businessProfile,
        isCurrent: status.steps.createOrganization && !status.steps.businessProfile,
      ),
      _StepData(
        label: 'Branding',
        subtitle: 'Set up your brand identity',
        isCompleted: status.steps.branding,
        isCurrent: status.steps.businessProfile && !status.steps.branding,
      ),
      _StepData(
        label: 'Preferences',
        subtitle: 'Configure your settings',
        isCompleted: status.steps.preferences,
        isCurrent: status.steps.branding && !status.steps.preferences,
      ),
      _StepData(
        label: 'Review & Activate',
        subtitle: 'Final review to go live',
        isCompleted: status.steps.activation,
        isCurrent: status.steps.preferences && !status.steps.activation,
      ),
    ];
  }
}

class _StepData {
  final String label;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  _StepData({
    required this.label,
    required this.subtitle,
    required this.isCompleted,
    required this.isCurrent,
  });
}

class _TimelineStep extends StatelessWidget {
  final _StepData step;
  final bool isLast;
  final int index;

  const _TimelineStep({
    required this.step,
    required this.isLast,
    required this.index,
  });

  Color get _indicatorColor {
    if (step.isCompleted) return AppColors.stepCompleted;
    if (step.isCurrent) return AppColors.stepCurrent;
    return AppColors.stepPending;
  }

  IconData? get _icon {
    if (step.isCompleted) return Icons.check;
    if (step.isCurrent) return Icons.circle;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _indicatorColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _icon != null
                        ? Icon(_icon, size: 16, color: Colors.white)
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.stepPending,
                              shape: BoxShape.circle,
                            ),
                          ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: step.isCompleted ? AppColors.stepCompleted : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: step.isCompleted || step.isCurrent
                          ? AppColors.text
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.subtitle,
                    style: AppTypography.caption.copyWith(
                      color: step.isCompleted || step.isCurrent
                          ? AppColors.textSecondary
                          : AppColors.stepPending,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

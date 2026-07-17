import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

enum TimelineStatus { completed, current, pending }

class TimelineStep extends StatelessWidget {
  final String label;
  final TimelineStatus status;
  final bool isLast;

  const TimelineStep({
    super.key,
    required this.label,
    this.status = TimelineStatus.pending,
    this.isLast = false,
  });

  Color _circleColor() {
    switch (status) {
      case TimelineStatus.completed:
        return AppColors.stepCompleted;
      case TimelineStatus.current:
        return AppColors.stepCurrent;
      case TimelineStatus.pending:
        return AppColors.stepPending;
    }
  }

  Widget _circleContent() {
    switch (status) {
      case TimelineStatus.completed:
        return const Icon(Icons.check, color: Colors.white, size: 18);
      case TimelineStatus.current:
        return Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.stepCurrent,
            shape: BoxShape.circle,
          ),
        );
      case TimelineStatus.pending:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.stepPending,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: status == TimelineStatus.completed ? 28 : 24,
                  height: status == TimelineStatus.completed ? 28 : 24,
                  decoration: BoxDecoration(
                    color: _circleColor(),
                    shape: BoxShape.circle,
                    boxShadow: status == TimelineStatus.current
                        ? [
                            BoxShadow(
                              color: AppColors.stepCurrent.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _circleContent(),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: status == TimelineStatus.completed
                          ? AppColors.stepCompleted
                          : AppColors.stepPending.withOpacity(0.4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: UiConstants.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: status == TimelineStatus.completed ? 2 : 3,
                bottom: isLast ? 0 : UiConstants.md,
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: AppTypography.body.copyWith(
                  color: status == TimelineStatus.pending
                      ? AppColors.textSecondary
                      : AppColors.text,
                  fontWeight: status == TimelineStatus.current
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                child: Text(label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

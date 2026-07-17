import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/onboarding/models/onboarding_status.dart';

class ProgressSection extends StatelessWidget {
  final OnboardingStatus status;

  const ProgressSection({super.key, required this.status});

  String _encouragement() {
    final done = status.completedCount;
    if (done == 0) return 'Every journey begins with a single step.';
    if (done == 1) return 'You\'re on your way — keep going!';
    if (done == 2) return 'Half the battle is showing up. You\'re doing great!';
    if (done == 3) return 'Almost there! Just a couple more steps.';
    if (done == 4) return 'One last push to the finish line!';
    return 'You\'re all set!';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: _ProgressRingPainter(
              progress: status.progress,
              completedColor: AppColors.stepCompleted,
              currentColor: AppColors.stepCurrent,
              pendingColor: AppColors.stepPending,
            ),
            child: Center(
              child: Text(
                '${(status.progress * 100).toInt()}%',
                style: AppTypography.h3.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${status.completedCount} of ${status.totalSteps} steps complete',
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                _encouragement(),
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color completedColor;
  final Color currentColor;
  final Color pendingColor;

  _ProgressRingPainter({
    required this.progress,
    required this.completedColor,
    required this.currentColor,
    required this.pendingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) - 4;
    const strokeWidth = 6.0;

    final backgroundPaint = Paint()
      ..color = pendingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = progress >= 1.0 ? completedColor : currentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

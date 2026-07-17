import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SuccessAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const SuccessAnimation({
    super.key,
    this.onComplete,
  });

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _rotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        Future.delayed(const Duration(milliseconds: 500), widget.onComplete!);
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          final paintProgress = _controller.value >= 0.5
              ? (_controller.value - 0.5) / 0.5
              : 0.0;

          return Transform.scale(
            scale: _scale.value,
            child: Transform.rotate(
              angle: _rotation.value,
              child: CustomPaint(
                size: const Size(120, 120),
                painter: _CheckmarkPainter(
                  progress: paintProgress.clamp(0.0, 1.0),
                  color: AppColors.success,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final linePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      final path = Path();
      final startX = center.dx - radius * 0.35;
      final startY = center.dy;
      final midX = center.dx - radius * 0.08;
      final midY = center.dy + radius * 0.3;
      final endX = center.dx + radius * 0.4;
      final endY = center.dy - radius * 0.25;

      final totalLength = _dist(startX, startY, midX, midY) +
          _dist(midX, midY, endX, endY);
      final drawnLength = totalLength * progress;

      double remaining = drawnLength;

      final firstSegLen = _dist(startX, startY, midX, midY);
      if (remaining <= firstSegLen) {
        final t = remaining / firstSegLen;
        path.moveTo(startX, startY);
        path.lineTo(
          startX + (midX - startX) * t,
          startY + (midY - startY) * t,
        );
      } else {
        path.moveTo(startX, startY);
        path.lineTo(midX, midY);
        remaining -= firstSegLen;

        final secondSegLen = _dist(midX, midY, endX, endY);
        final t = (secondSegLen > 0) ? remaining / secondSegLen : 0.0;
        path.lineTo(
          midX + (endX - midX) * t,
          midY + (endY - midY) * t,
        );
      }

      canvas.drawPath(path, linePaint);
    }
  }

  double _dist(double x1, double y1, double x2, double y2) {
    return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) => progress != old.progress;
}

import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const ConfettiAnimation({super.key, this.onComplete});

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ConfettiParticle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });

    _particles = List.generate(30, (_) => _ConfettiParticle(_random));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: _ConfettiPainter(
          particles: _particles,
          progress: _controller.value,
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  final double startX;
  final double endX;
  final double startY;
  final double endY;
  final Color color;
  final double size;
  final double rotation;
  final double delay;

  _ConfettiParticle(Random random)
      : startX = random.nextDouble();
  _init(random);

  void _init(Random random) {
    endX = startX + (random.nextDouble() - 0.5) * 0.4;
    startY = -0.05 - random.nextDouble() * 0.1;
    endY = 0.85 + random.nextDouble() * 0.15;
    color = _confettiColors[random.nextInt(_confettiColors.length)];
    size = 4 + random.nextDouble() * 4;
    rotation = random.nextDouble() * 2 * pi;
    delay = random.nextDouble() * 0.4;
  }
}

final _confettiColors = [
  const Color(0xFF2563EB),
  const Color(0xFF22C55E),
  const Color(0xFFF59E0B),
  const Color(0xFFEF4444),
  const Color(0xFF8B5CF6),
  const Color(0xFFEC4899),
  const Color(0xFF0D9488),
];

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0, 1);
      if (t <= 0) continue;

      final x = lerpDouble(p.startX, p.endX, t)! * size.width;
      final y = lerpDouble(p.startY, p.endY, t)! * size.height;
      final opacity = t < 0.8 ? 1.0 : (1 - t) * 5;
      final scale = t < 0.1 ? t * 10 : 1.0;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation * t);
      canvas.scale(scale);

      final paint = Paint()..color = p.color.withValues(alpha: opacity);
      canvas.drawCircle(Offset.zero, p.size, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class CheckmarkAnimation extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final VoidCallback? onComplete;

  const CheckmarkAnimation({
    super.key,
    this.size = 80,
    this.strokeWidth = 4,
    this.color = const Color(0xFF22C55E),
    this.onComplete,
  });

  @override
  State<CheckmarkAnimation> createState() => _CheckmarkAnimationState();
}

class _CheckmarkAnimationState extends State<CheckmarkAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _drawProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });

    _drawProgress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _drawProgress,
      builder: (context, child) => CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _CheckmarkPainter(
          progress: _drawProgress.value,
          strokeWidth: widget.strokeWidth,
          color: widget.color,
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _CheckmarkPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - strokeWidth;

    final p1 = Offset(cx - r * 0.45, cy - r * 0.1);
    final p2 = Offset(cx - r * 0.1, cy + r * 0.35);
    final p3 = Offset(cx + r * 0.5, cy - r * 0.3);

    final totalLength = _dist(p1, p2) + _dist(p2, p3);
    final firstSegment = _dist(p1, p2) / totalLength;

    if (progress < firstSegment) {
      final t = progress / firstSegment;
      final mid = Offset.lerp(p1, p2, t)!;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(mid.dx, mid.dy);
    } else {
      final t = (progress - firstSegment) / (1 - firstSegment);
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      final mid = Offset.lerp(p2, p3, t)!;
      path.lineTo(mid.dx, mid.dy);
    }

    canvas.drawPath(path, paint);
  }

  double _dist(Offset a, Offset b) {
    return (a - b).distance;
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class CelebrationOverlay extends StatefulWidget {
  final String message;
  final VoidCallback? onComplete;

  const CelebrationOverlay({
    super.key,
    required this.message,
    this.onComplete,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _checkmarkDelay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeInOutCubic),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _checkmarkDelay = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.5, curve: Curves.easeInOutCubic),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _fadeIn,
        child: Stack(
          children: [
            const ConfettiAnimation(),
            Center(
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckmarkAnimation(
                      onComplete: _checkmarkDelay.isCompleted ? () {} : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

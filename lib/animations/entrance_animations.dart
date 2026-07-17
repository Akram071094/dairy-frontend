import 'package:flutter/material.dart';

class SlideInUp extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const SlideInUp({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<SlideInUp> createState() => _SlideInUpState();
}

class _SlideInUpState extends State<SlideInUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const FadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}

class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration delayBetween;
  final Duration duration;

  const StaggeredList({
    super.key,
    required this.children,
    this.delayBetween = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _opacities;
  late final List<Animation<Offset>> _offsets;

  @override
  void initState() {
    super.initState();
    final totalDuration = widget.duration +
        widget.delayBetween * (widget.children.length - 1);
    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    _opacities = List.generate(widget.children.length, (i) {
      final start = (widget.delayBetween * i).inMilliseconds /
          totalDuration.inMilliseconds;
      final end = (widget.delayBetween * i + widget.duration).inMilliseconds /
          totalDuration.inMilliseconds;
      return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start.clamp(0, 1), end.clamp(0, 1),
            curve: Curves.easeInOutCubic),
      ));
    });

    _offsets = List.generate(widget.children.length, (i) {
      final start = (widget.delayBetween * i).inMilliseconds /
          totalDuration.inMilliseconds;
      final end = (widget.delayBetween * i + widget.duration).inMilliseconds /
          totalDuration.inMilliseconds;
      return Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start.clamp(0, 1), end.clamp(0, 1),
            curve: Curves.easeInOutCubic),
      ));
    });

    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.children,
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.children.length, (i) {
            return SlideTransition(
              position: _offsets[i],
              child: FadeTransition(
                opacity: _opacities[i],
                child: widget.children[i],
              ),
            );
          }),
        );
      },
    );
  }
}

class ScaleIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const ScaleIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

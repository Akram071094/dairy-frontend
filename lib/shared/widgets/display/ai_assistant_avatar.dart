import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ui_constants.dart';

enum AiMood { smiling, thinking, celebrating }

class AiAssistantAvatar extends StatefulWidget {
  final double size;
  final AiMood mood;

  const AiAssistantAvatar({
    super.key,
    this.size = 56,
    this.mood = AiMood.smiling,
  });

  @override
  State<AiAssistantAvatar> createState() => _AiAssistantAvatarState();
}

class _AiAssistantAvatarState extends State<AiAssistantAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _emoji() {
    switch (widget.mood) {
      case AiMood.smiling:
        return '\u{1F404}';
      case AiMood.thinking:
        return '\u{1F914}';
      case AiMood.celebrating:
        return '\u{1F389}';
    }
  }

  Color _bgColor() {
    switch (widget.mood) {
      case AiMood.smiling:
        return AppColors.primaryLight;
      case AiMood.thinking:
        return AppColors.warningLight;
      case AiMood.celebrating:
        return AppColors.successLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _float,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _float.value),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _bgColor(),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _emoji(),
            style: TextStyle(fontSize: widget.size * 0.45),
          ),
        ),
      ),
    );
  }
}

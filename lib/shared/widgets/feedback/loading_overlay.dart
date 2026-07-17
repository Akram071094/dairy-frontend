import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

enum LoadingAnimationType {
  document,
  building,
  data,
  color,
  gear,
  rocket,
  upload,
  generic,
}

class LoadingOverlay extends StatefulWidget {
  final String message;
  final LoadingAnimationType animationType;

  const LoadingOverlay({
    super.key,
    required this.message,
    this.animationType = LoadingAnimationType.generic,
  });

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  IconData _icon() {
    switch (widget.animationType) {
      case LoadingAnimationType.document:
        return Icons.description;
      case LoadingAnimationType.building:
        return Icons.business;
      case LoadingAnimationType.data:
        return Icons.storage;
      case LoadingAnimationType.color:
        return Icons.palette;
      case LoadingAnimationType.gear:
        return Icons.settings;
      case LoadingAnimationType.rocket:
        return Icons.rocket_launch;
      case LoadingAnimationType.upload:
        return Icons.cloud_upload;
      case LoadingAnimationType.generic:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withValues(alpha: 0.4),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListenableBuilder(
                listenable: _pulse,
                builder: (context, child) => Transform.scale(
                  scale: _pulse.value,
                  child: child,
                ),
                child: Icon(
                  _icon(),
                  size: 64,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: UiConstants.lg),
              ListenableBuilder(
                listenable: _pulse,
                builder: (context, child) => Opacity(
                  opacity: _pulse.value,
                  child: child,
                ),
                child: Text(
                  widget.message,
                  style: AppTypography.h3.copyWith(color: AppColors.textOnPrimary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

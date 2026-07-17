import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  String _animationAsset() {
    switch (widget.animationType) {
      case LoadingAnimationType.document:
        return 'assets/animations/document.json';
      case LoadingAnimationType.building:
        return 'assets/animations/building.json';
      case LoadingAnimationType.data:
        return 'assets/animations/data.json';
      case LoadingAnimationType.color:
        return 'assets/animations/color.json';
      case LoadingAnimationType.gear:
        return 'assets/animations/gear.json';
      case LoadingAnimationType.rocket:
        return 'assets/animations/rocket.json';
      case LoadingAnimationType.upload:
        return 'assets/animations/upload.json';
      case LoadingAnimationType.generic:
        return 'assets/animations/loading.json';
    }
  }

  IconData _fallbackIcon() {
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
          color: Colors.black.withOpacity(0.4),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  _animationAsset(),
                  errorBuilder: (context, error, stackTrace) => Icon(
                    _fallbackIcon(),
                    size: 64,
                    color: AppColors.textOnPrimary,
                  ),
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

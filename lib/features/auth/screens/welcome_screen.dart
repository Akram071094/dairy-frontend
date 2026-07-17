import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/constants/ui_constants.dart';
import 'package:dairy_frontend/core/router/app_router.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/shared/widgets/buttons/primary_button.dart';
import 'package:dairy_frontend/shared/widgets/buttons/secondary_button.dart';
import 'package:dairy_frontend/shared/widgets/display/ai_assistant_avatar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: UiConstants.slideDuration * 4),
    );
    _slideAnimations = List.generate(5, (i) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.15,
            0.4 + i * 0.15,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });
    _fadeAnimations = List.generate(5, (i) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.15,
            0.4 + i * 0.15,
            curve: Curves.easeIn,
          ),
        ),
      );
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildAnimatedItem(
                index: 0,
                child: const AiAssistantAvatar(size: 120),
              ),
              const SizedBox(height: 32),
              _buildAnimatedItem(
                index: 1,
                child: Text(
                  'Zheng',
                  style: AppTypography.display,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              _buildAnimatedItem(
                index: 2,
                child: Text(
                  'AI-powered dairy distribution management',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 2),
              _buildAnimatedItem(
                index: 3,
                child: PrimaryButton(
                  label: 'Get Started',
                  onTap: () => context.go(AppRouter.signup),
                ),
              ),
              const SizedBox(height: 12),
              _buildAnimatedItem(
                index: 4,
                child: SecondaryButton(
                  label: 'I have an account',
                  onTap: () => context.go(AppRouter.login),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Version ${AppConstants.appVersion}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      ),
    );
  }
}

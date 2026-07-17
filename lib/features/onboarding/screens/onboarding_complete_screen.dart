import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/constants/ui_constants.dart';
import 'package:dairy_frontend/core/router/app_router.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/shared/widgets/buttons/primary_button.dart';

class OnboardingCompleteScreen extends StatefulWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  State<OnboardingCompleteScreen> createState() => _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends State<OnboardingCompleteScreen>
    with TickerProviderStateMixin {
  late final AnimationController _rocketController;
  late final AnimationController _contentController;
  late final Animation<double> _rocketFloat;
  late final Animation<double> _rocketRise;
  late final Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _features = const [
    {'icon': Icons.shopping_cart_outlined, 'title': 'Retailers', 'desc': 'Manage your retailer network & orders'},
    {'icon': Icons.inventory_2_outlined, 'title': 'Inventory', 'desc': 'Real-time stock & movement tracking'},
    {'icon': Icons.route_outlined, 'title': 'Planning & Delivery', 'desc': 'Smart routing and dispatch'},
    {'icon': Icons.payments_outlined, 'title': 'Collections', 'desc': 'Track payments & dues seamlessly'},
    {'icon': Icons.insights_outlined, 'title': 'AI Assistant', 'desc': 'Mia helps you run the business'},
  ];

  @override
  void initState() {
    super.initState();
    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: UiConstants.celebrationDuration),
    );
    _rocketFloat = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _rocketController, curve: Curves.easeInOut),
    );
    _rocketRise = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );
    _rocketController.repeat(reverse: true);
    _contentController.forward();
  }

  @override
  void dispose() {
    _rocketController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _rocketFloat,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, -_rocketFloat.value),
                  child: child,
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.rocket_launch_rounded,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _rocketRise,
                builder: (context, child) => Transform.scale(
                  scale: _rocketRise.value,
                  child: Opacity(opacity: _fadeAnim.value, child: child),
                ),
                child: Column(
                  children: [
                    Text(
                      "We're launching ${AppConstants.appName}!",
                      style: AppTypography.display.copyWith(color: AppColors.text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your business is live. Here is what you can do next:',
                      style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AnimatedBuilder(
                animation: _fadeAnim,
                builder: (context, child) => Opacity(opacity: _fadeAnim.value, child: child),
                child: Column(
                  children: _features
                      .map((f) => _featureTile(f['icon'], f['title'], f['desc']))
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _fadeAnim,
                builder: (context, child) => Opacity(opacity: _fadeAnim.value, child: child),
                child: Container(
                  padding: AppDimensions.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: AppDimensions.radiusMd,
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'M',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "I'm ${AppConstants.aiAssistantName}, your AI assistant — I'll help you every step of the way!",
                          style: AppTypography.bodySmall.copyWith(color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
      PrimaryButton(
        label: 'Sign in to continue',
        onTap: () => context.go(AppRouter.login),
        icon: const Icon(Icons.login_rounded, size: 20),
      ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureTile(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppDimensions.radiusSm,
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(desc, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

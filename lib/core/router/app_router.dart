import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/onboarding/screens/action_center_screen.dart';
import '../../features/onboarding/screens/business_setup_screen.dart';
import '../../features/onboarding/screens/business_profile_screen.dart';
import '../../features/onboarding/screens/branding_screen.dart';
import '../../features/onboarding/screens/preferences_screen.dart';
import '../../features/onboarding/screens/review_screen.dart';
import '../../features/onboarding/screens/onboarding_complete_screen.dart';
import '../../features/chat/screens/mia_chat_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String actionCenter = '/action-center';
  static const String businessSetup = '/business-setup';
  static const String businessProfile = '/business-profile';
  static const String branding = '/branding';
  static const String preferences = '/preferences';
  static const String review = '/review';
  static const String onboardingComplete = '/complete';
  static const String dashboard = '/app';
  static const String miaChat = '/mia';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: welcome, builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: signup, builder: (_, __) => const SignupScreen()),
      GoRoute(
        path: actionCenter,
        builder: (_, __) => const ActionCenterScreen(),
        routes: [
          GoRoute(
            path: 'business-setup',
            builder: (_, state) => const BusinessSetupScreen(),
          ),
          GoRoute(
            path: 'business-profile',
            builder: (_, state) => const BusinessProfileScreen(),
          ),
          GoRoute(
            path: 'branding',
            builder: (_, state) => const BrandingScreen(),
          ),
          GoRoute(
            path: 'preferences',
            builder: (_, state) => const PreferencesScreen(),
          ),
          GoRoute(
            path: 'review',
            builder: (_, state) => const ReviewScreen(),
          ),
          GoRoute(
            path: 'complete',
            builder: (_, state) => const OnboardingCompleteScreen(),
          ),
        ],
      ),
      GoRoute(path: dashboard, builder: (_, __) => const MiaChatScreen()),
      GoRoute(path: miaChat, builder: (_, __) => const MiaChatScreen()),
    ],
    errorBuilder: (_, __) => const Scaffold(
      body: Center(child: Text('Page not found')),
    ),
  );
}

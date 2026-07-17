import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/services/auth_service.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/onboarding/services/onboarding_service.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  final prefs = await SharedPreferences.getInstance();
  final apiClient = ApiClient(storage: storage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: AuthService(apiClient: apiClient),
            storage: storage,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(
            onboardingService: OnboardingService(apiClient: apiClient),
            prefs: prefs,
          ),
        ),
      ],
      child: const DairyApp(),
    ),
  );
}

class DairyApp extends StatelessWidget {
  const DairyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

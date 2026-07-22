import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/router/app_router.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/core/utils/validators.dart';
import 'package:dairy_frontend/features/auth/models/auth_models.dart';
import 'package:dairy_frontend/features/auth/providers/auth_provider.dart';
import 'package:dairy_frontend/shared/widgets/buttons/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    await authProvider.signup(
      SignupRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      ),
    );
    if (!mounted) return;
    if (authProvider.isAuthenticated) {
      context.go('/action-center');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go(AppRouter.welcome),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.text,
                  ),
                ),
                const SizedBox(height: 24),
                Text('Create your account', style: AppTypography.h1),
                const SizedBox(height: 8),
                Text(
                  'Join ${AppConstants.appName}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'First name',
                          hintText: 'John',
                        ),
                        validator: (v) => Validators.optionalName(v, 'First name'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Last name',
                          hintText: 'Doe',
                        ),
                        validator: (v) => Validators.optionalName(v, 'Last name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Create a password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: Validators.password,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'At least 8 characters, 1 uppercase letter, 1 number',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                  onFieldSubmitted: (_) => _handleSignup(),
                ),
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    if (auth.error != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            auth.error!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return PrimaryButton(
                      label: 'Create Account',
                      isLoading: auth.isLoading,
                      onTap: _handleSignup,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRouter.login),
                      child: Text(
                        'Sign in',
                        style: AppTypography.link,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/onboarding/providers/onboarding_provider.dart';
import 'package:dairy_frontend/features/onboarding/widgets/hero_section.dart';
import 'package:dairy_frontend/features/onboarding/widgets/progress_section.dart';
import 'package:dairy_frontend/features/onboarding/widgets/next_action_card.dart';
import 'package:dairy_frontend/features/onboarding/widgets/activity_timeline.dart';
import 'package:dairy_frontend/features/onboarding/widgets/quick_actions.dart';

class ActionCenterScreen extends StatefulWidget {
  const ActionCenterScreen({super.key});

  @override
  State<ActionCenterScreen> createState() => _ActionCenterScreenState();
}

class _ActionCenterScreenState extends State<ActionCenterScreen> {
  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final provider = context.read<OnboardingProvider>();
    final prefs = await SharedPreferences.getInstance();
    final orgId = prefs.getString(AppConstants.currentOrgIdKey);
    if (orgId != null && orgId.isNotEmpty) {
      provider.loadStatus(orgId);
    }
  }

  void _onNextActionTap(BuildContext context, OnboardingProvider provider) {
    final status = provider.status;
    if (status == null) return;
    if (!status.steps.createOrganization) {
      context.push('/action-center/business-setup');
    } else if (!status.steps.businessProfile) {
      context.push('/action-center/business-profile');
    } else if (!status.steps.branding) {
      context.push('/action-center/branding');
    } else if (!status.steps.preferences) {
      context.push('/action-center/preferences');
    } else if (!status.steps.activation) {
      context.push('/action-center/review');
    }
  }

  List<QuickAction> _buildQuickActions(OnboardingProvider provider) {
    final status = provider.status;
    if (status == null) return [];
    final actions = <QuickAction>[];
    if (status.steps.createOrganization) {
      actions.add(QuickAction(
        label: 'Edit Business',
        icon: Icons.edit,
        onTap: () => context.push('/action-center/business-setup'),
      ));
    }
    if (status.steps.businessProfile) {
      actions.add(QuickAction(
        label: 'Edit Profile',
        icon: Icons.edit,
        onTap: () => context.push('/action-center/business-profile'),
      ));
    }
    if (status.steps.branding) {
      actions.add(QuickAction(
        label: 'Edit Branding',
        icon: Icons.edit,
        onTap: () => context.push('/action-center/branding'),
      ));
    }
    if (status.steps.preferences) {
      actions.add(QuickAction(
        label: 'Edit Preferences',
        icon: Icons.edit,
        onTap: () => context.push('/action-center/preferences'),
      ));
    }
    if (status.isComplete) {
      actions.add(QuickAction(
        label: 'Go to Dashboard',
        icon: Icons.dashboard,
        onTap: () {},
      ));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
        centerTitle: true,
      ),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.status == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.status == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Something went wrong', style: AppTypography.body),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadStatus,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (provider.status == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.business, size: 64, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to ${AppConstants.appName}',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s get your business set up!',
                    style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/action-center/business-setup'),
                    icon: const Icon(Icons.add),
                    label: const Text('Get Started'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          final status = provider.status!;
          return RefreshIndicator(
            onRefresh: _loadStatus,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppDimensions.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroSection(status: status),
                  const SizedBox(height: 24),
                  ProgressSection(status: status),
                  const SizedBox(height: 24),
                  NextActionCard(
                    status: status,
                    onTap: () => _onNextActionTap(context, provider),
                  ),
                  const SizedBox(height: 24),
                  Text('Activity', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  ActivityTimeline(status: status),
                  const SizedBox(height: 24),
                  Text('Quick Actions', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  QuickActions(actions: _buildQuickActions(provider)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

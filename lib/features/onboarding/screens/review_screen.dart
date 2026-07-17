import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/onboarding/providers/onboarding_provider.dart';
import 'package:dairy_frontend/features/onboarding/widgets/summary_card.dart';
import 'package:dairy_frontend/shared/widgets/buttons/primary_button.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final org = provider.organization;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Activate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: AppDimensions.cardPadding,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.success, Color(0xFF16A34A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppDimensions.radiusMd,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.checklist, color: AppColors.success, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Almost there, ${AppConstants.aiAssistantName}!',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Review everything before we go live.',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (org != null) ...[
              SummaryCard(
                title: 'Business Identity',
                icon: Icons.business,
                onEdit: () => context.push('/action-center/business-setup'),
                fields: {
                  'Business Code': org.businessCode,
                  'Display Name': org.displayName,
                  'Legal Name': org.legalName,
                  'GST Number': org.gstNumber,
                  'FSSAI License': org.fssaiLicenseNumber,
                  'Business Type': org.businessType,
                },
              ),
              const SizedBox(height: 12),
              SummaryCard(
                title: 'Contact & Address',
                icon: Icons.contact_mail,
                onEdit: () => context.push('/action-center/business-setup'),
                fields: {
                  'Contact Name': org.primaryContactName,
                  'Email': org.primaryContactEmail,
                  'Phone': org.primaryContactPhone,
                  'Country': org.country,
                  'State': org.state,
                  'City': org.city,
                  'Address': org.address,
                  'Postal Code': org.postalCode,
                },
              ),
              const SizedBox(height: 12),
              SummaryCard(
                title: 'Configuration',
                icon: Icons.settings,
                onEdit: () => context.push('/action-center/business-setup'),
                fields: {
                  'Timezone': org.timezone,
                  'Currency': org.currency,
                  'Language': org.language,
                },
              ),
            ],
            const SizedBox(height: 12),
            SummaryCard(
              title: 'Business Profile',
              icon: Icons.assignment,
              onEdit: () => context.push('/action-center/business-profile'),
              fields: {
                'Registration': 'Completed',
                'Industry': 'Provided',
              },
            ),
            const SizedBox(height: 12),
            SummaryCard(
              title: 'Branding',
              icon: Icons.palette,
              onEdit: () => context.push('/action-center/branding'),
              fields: {
                'Primary Color': org != null ? 'Set' : 'Default',
                'Secondary Color': org != null ? 'Set' : 'Default',
              },
            ),
            const SizedBox(height: 12),
            SummaryCard(
              title: 'Preferences',
              icon: Icons.tune,
              onEdit: () => context.push('/action-center/preferences'),
              fields: {
                'Working Days': 'Configured',
                'Working Hours': 'Set',
              },
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Activate Business \u{1F680}',
              onTap: () => _onActivate(context, provider),
              isLoading: provider.isLoading,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Go back to Action Center',
                  style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onActivate(BuildContext context, OnboardingProvider provider) async {
    final orgId = provider.organization?.id;
    if (orgId == null || orgId.isEmpty) return;
    await provider.activateOrg(orgId);
    if (context.mounted) {
      context.go('/action-center/complete');
    }
  }
}

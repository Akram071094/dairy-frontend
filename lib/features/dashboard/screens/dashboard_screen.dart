import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/auth/providers/auth_provider.dart';
import 'package:dairy_frontend/features/dashboard/providers/dashboard_provider.dart';
import 'package:dairy_frontend/features/dashboard/widgets/kpi_card.dart';
import 'package:dairy_frontend/features/dashboard/widgets/recent_activity_tile.dart';
import 'package:dairy_frontend/features/dashboard/widgets/quick_action_card.dart';
import 'package:dairy_frontend/features/dashboard/models/dashboard_models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.firstName ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppDimensions.radiusSm,
              ),
              child: const Center(
                child: Text(
                  'MD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'MindFleet Dairy',
              style: AppTypography.h3.copyWith(color: AppColors.text),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.summary == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.summary == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Text(
                    'Unable to load dashboard',
                    style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => provider.loadSummary(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final summary = provider.summary;
          final kpis = summary != null
              ? [
                  KpiCardData(
                    label: 'Retailers',
                    value: summary.totalRetailers.toString(),
                    icon: Icons.store_rounded,
                    change: '+2',
                    isPositive: true,
                  ),
                  KpiCardData(
                    label: 'Active Deliveries',
                    value: summary.activeDeliveries.toString(),
                    icon: Icons.local_shipping_rounded,
                    change: null,
                    isPositive: true,
                  ),
                  KpiCardData(
                    label: "Today's Collections",
                    value: '\$${summary.todayCollections.toStringAsFixed(0)}',
                    icon: Icons.payments_rounded,
                    change: '+12%',
                    isPositive: true,
                  ),
                  KpiCardData(
                    label: 'Outstanding',
                    value: '\$${summary.totalOutstanding.toStringAsFixed(0)}',
                    icon: Icons.account_balance_rounded,
                    change: summary.totalOutstanding > 0 ? '-5%' : null,
                    isPositive: summary.totalOutstanding <= 0,
                  ),
                ]
              : [];

          return RefreshIndicator(
            onRefresh: () => provider.loadSummary(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: AppTypography.h1.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Here\'s what\'s happening with your business today.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: kpis.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => KpiCard(
                        label: kpis[i].label,
                        value: kpis[i].value,
                        icon: kpis[i].icon,
                        change: kpis[i].change,
                        isPositive: kpis[i].isPositive,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Activity",
                        style: AppTypography.h3.copyWith(color: AppColors.text),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppDimensions.radiusMd,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: summary != null && summary.recentActivities.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: summary.recentActivities.length > 5
                                ? 5
                                : summary.recentActivities.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: AppColors.border,
                            ),
                            itemBuilder: (_, i) => RecentActivityTile(
                              activity: summary.recentActivities[i],
                              onTap: () {},
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No recent activity',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Quick Actions',
                    style: AppTypography.h3.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      QuickActionCard(
                        icon: Icons.person_add_rounded,
                        title: 'New Retailer',
                        subtitle: 'Add a retailer',
                        color: AppColors.primary,
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      QuickActionCard(
                        icon: Icons.receipt_long_rounded,
                        title: 'Create Order',
                        subtitle: 'New delivery order',
                        color: AppColors.secondary,
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      QuickActionCard(
                        icon: Icons.payments_rounded,
                        title: 'Record Collection',
                        subtitle: 'Log payment',
                        color: AppColors.warning,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning!';
    if (hour < 17) return 'Good afternoon!';
    return 'Good evening!';
  }
}

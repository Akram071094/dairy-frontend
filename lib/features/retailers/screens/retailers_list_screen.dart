import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/shared/widgets/display/action_card.dart';

class RetailersListScreen extends StatelessWidget {
  const RetailersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Text(
          'Retailers',
          style: AppTypography.h3.copyWith(color: AppColors.text),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
            color: AppColors.textSecondary,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
            color: AppColors.textSecondary,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: AppDimensions.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: AppDimensions.radiusMd,
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.construction_rounded, color: AppColors.warning, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coming Soon',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Retailer management will be available in the next update.',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ActionCard(
            icon: Icons.person_add_rounded,
            title: 'Add New Retailer',
            description: 'Register a new retailer to your network',
            buttonLabel: 'Add Retailer',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _placeholderRetailerCard('Fresh Dairy Shop', '123 Main St', 'Active', 12),
          _placeholderRetailerCard('City Milk Depot', '456 Oak Ave', 'Active', 8),
          _placeholderRetailerCard('Corner Store Dairy', '789 Pine Rd', 'Inactive', 0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _placeholderRetailerCard(String name, String address, String status, int pendingOrders) {
    final isActive = status == 'Active';
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
              color: isActive ? AppColors.successLight : AppColors.surfaceDim,
              borderRadius: AppDimensions.radiusSm,
            ),
            child: Center(
              child: Icon(
                Icons.store_rounded,
                color: isActive ? AppColors.success : AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.successLight : AppColors.errorLight,
              borderRadius: AppDimensions.radiusSm,
            ),
            child: Text(
              status,
              style: AppTypography.caption.copyWith(
                color: isActive ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

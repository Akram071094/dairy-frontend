import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

class BrandPreviewCard extends StatelessWidget {
  final Color? primaryColor;
  final Color? secondaryColor;
  final String? logoUrl;
  final String businessName;

  const BrandPreviewCard({
    super.key,
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? AppColors.primary;
    final secondary = secondaryColor ?? AppColors.secondary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: logoUrl != null
                  ? Image.network(
                      logoUrl!,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildLogoPlaceholder(40),
                    )
                  : _buildLogoPlaceholder(40),
            ),
          ),
          Padding(
            padding: AppDimensions.cardPadding,
            child: Column(
              children: [
                const SizedBox(height: UiConstants.sm),
                Text(
                  businessName,
                  style: AppTypography.h2.copyWith(color: AppColors.text),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: UiConstants.xs),
                Text(
                  'Your Dairy Business',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: UiConstants.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _colorDot(primary),
                    const SizedBox(width: 8),
                    _colorDot(secondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.store,
        color: Colors.white.withOpacity(0.8),
        size: size * 0.5,
      ),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
      ),
    );
  }
}

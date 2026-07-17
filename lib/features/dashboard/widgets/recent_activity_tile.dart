import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/dashboard/models/dashboard_models.dart';

class RecentActivityTile extends StatelessWidget {
  final RecentActivity activity;
  final VoidCallback? onTap;

  const RecentActivityTile({
    super.key,
    required this.activity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = activity.timestamp != null
        ? DateFormat('MMM d, h:mm a').format(activity.timestamp!)
        : '';

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.radiusMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: activity.color.withValues(alpha: 0.12),
                borderRadius: AppDimensions.radiusSm,
              ),
              child: Icon(
                activity.icon,
                size: 18,
                color: activity.color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      timeStr,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

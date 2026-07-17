import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/ui_constants.dart';

class UploadCard extends StatelessWidget {
  final String label;
  final String? fileUrl;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const UploadCard({
    super.key,
    required this.label,
    this.fileUrl,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusMd,
        border: fileUrl != null
            ? Border.all(color: AppColors.border)
            : Border.all(
                color: AppColors.border,
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: UiConstants.md),
          if (fileUrl != null)
            _buildPreview()
          else
            _buildUploadArea(),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: onUpload,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: AppDimensions.radiusSm,
          color: AppColors.surfaceDim,
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(color: AppColors.border),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_upload_outlined, color: AppColors.textSecondary, size: 36),
                SizedBox(height: 8),
                const Text('Tap to upload'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: AppDimensions.radiusSm,
          child: Image.network(
            fileUrl!,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              color: AppColors.surfaceDim,
              child: const Center(
                child: Icon(Icons.broken_image, color: AppColors.textSecondary, size: 40),
              ),
            ),
          ),
        ),
        const SizedBox(height: UiConstants.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: onUpload,
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: Text('Change', style: AppTypography.bodySmall),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            const SizedBox(width: UiConstants.md),
            TextButton.icon(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: Text('Remove', style: AppTypography.bodySmall),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
          ],
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashWidth = 8.0;
    const dashGap = 5.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8),
    );

    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => color != old.color;
}

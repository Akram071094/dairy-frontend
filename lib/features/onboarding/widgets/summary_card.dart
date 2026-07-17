import 'package:flutter/material.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';

class SummaryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Map<String, String?> fields;
  final VoidCallback? onEdit;

  const SummaryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.fields,
    this.onEdit,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final nonNullFields = widget.fields.entries.where((e) => e.value != null && e.value!.isNotEmpty).toList();
    if (nonNullFields.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: AppDimensions.radiusMd,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(widget.icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (widget.onEdit != null)
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Text('Edit', style: AppTypography.link),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: nonNullFields.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(
                            entry.key,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class DropdownField<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final String? hint;

  const DropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.hint,
  });

  InputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: AppDimensions.radiusMd,
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary.withOpacity(0.7),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: AppDimensions.fieldPadding,
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.borderFocus).copyWith(
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        errorBorder: _border(AppColors.borderError),
        focusedErrorBorder: _border(AppColors.borderError).copyWith(
          borderSide: const BorderSide(color: AppColors.borderError, width: 2),
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
      ),
      style: AppTypography.body.copyWith(color: AppColors.text),
      dropdownColor: AppColors.surface,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
      borderRadius: AppDimensions.radiusMd,
    );
  }
}

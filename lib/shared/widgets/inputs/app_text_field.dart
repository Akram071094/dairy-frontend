import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  InputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: AppDimensions.radiusMd,
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          maxLength: maxLength,
          minLines: minLines,
          maxLines: maxLines,
          autofocus: autofocus,
          enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          style: AppTypography.body.copyWith(color: AppColors.text),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            labelStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: prefixIcon,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: suffixIcon,
                  )
                : null,
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.surfaceDim,
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
            disabledBorder: _border(AppColors.border.withOpacity(0.5)),
            errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

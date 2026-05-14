import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelCaps.copyWith(
            color: AppColors.textLabel,
          ),
        ),
        const SizedBox(height: AppDimens.spaceS),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            fontSize: AppTextStyles.bodyLarge.fontSize,
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: AppTextStyles.bodyLarge.fontSize,
              color: AppColors.textHint,
              fontFamily: 'Inter',
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

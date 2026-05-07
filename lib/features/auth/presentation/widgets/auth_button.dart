import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.buttonHeight,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
            border: outlined ? Border.all(color: AppColors.primary, width: 1.5) : null,
            boxShadow: outlined ? null : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: outlined ? AppColors.primary : Colors.white,
                      fontSize: AppTextStyles.buttonPrimary.fontSize,
                      fontWeight: AppTextStyles.buttonPrimary.fontWeight,
                      letterSpacing: AppTextStyles.buttonPrimary.letterSpacing,
                      fontFamily: 'Inter',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

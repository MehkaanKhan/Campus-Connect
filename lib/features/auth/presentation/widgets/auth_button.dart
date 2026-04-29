import 'package:flutter/material.dart';
import '../../../../core/widgets/app_loader.dart';

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
    final child = isLoading
        ? const SizedBox(height: 22, width: 22, child: AppLoader())
        : Text(label);

    return outlined
        ? OutlinedButton(onPressed: isLoading ? null : onPressed, child: child)
        : ElevatedButton(onPressed: isLoading ? null : onPressed, child: child);
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CarpoolDividerLine extends StatelessWidget {
  const CarpoolDividerLine({super.key});

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: AppColors.border);
}

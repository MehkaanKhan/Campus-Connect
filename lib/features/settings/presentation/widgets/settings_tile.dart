import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final String? svgAsset;
  final IconData? materialIcon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    this.svgAsset,
    this.materialIcon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingIcon;
    if (svgAsset != null) {
      leadingIcon = SvgPicture.asset(
        svgAsset!,
        width: 22,
        height: 22,
        colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
      );
    } else {
      leadingIcon = Icon(materialIcon, color: AppColors.textSecondary);
    }

    return ListTile(
      leading: leadingIcon,
      title: Text(title),
      trailing: trailing ?? SvgPicture.asset(AppAssets.iconArrowRight, width: 18, height: 18, colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
      onTap: onTap,
    );
  }
}

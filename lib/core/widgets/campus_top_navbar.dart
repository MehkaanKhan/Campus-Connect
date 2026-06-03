import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

class CampusTopNavBar extends StatelessWidget {
  final VoidCallback? onBack;
  final Widget? trailing;

  const CampusTopNavBar({super.key, this.onBack, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(
          bottom: BorderSide(color: AppColors.navBorderTop, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (onBack != null) ...[
              GestureDetector(
                onTap: onBack,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    AppAssets.iconBackArrow,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
            GestureDetector(
              onTap: () => context.go('/home'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.headerLogo, width: 24, height: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Campus Connect',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (trailing != null)
              trailing!
            else
              GestureDetector(
                onTap: () => context.push('/search'),
                child: SvgPicture.asset(
                  AppAssets.iconSearch,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

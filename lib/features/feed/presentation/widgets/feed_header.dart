import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/feed_provider.dart';

class FeedHeader extends StatelessWidget {
  const FeedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    if (provider.isLoading) return const SizedBox.shrink();

    final universityName = provider.universityName;

    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$universityName Feed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 2.w),
              SvgPicture.asset(AppAssets.iconDropdown, width: 22.w, height: 22.w, colorFilter: ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Latest updates from your campus community.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

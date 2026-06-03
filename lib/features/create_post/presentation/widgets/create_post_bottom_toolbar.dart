import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/create_post_provider.dart';

class CreatePostBottomToolbar extends StatelessWidget {
  const CreatePostBottomToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();
    final charCount = provider.content.length;
    const maxChars = 280;
    final progress = charCount / maxChars;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24.w,
        16.h,
        24.w,
        MediaQuery.of(context).padding.bottom + 12.h,
      ),
      child: Row(
        children: [
          _ToolbarIcon(svgAsset: AppAssets.iconImagePlaceholder, onTap: () {
            provider.pickImage();
          }),
          SizedBox(width: 26.w),
          _ToolbarIcon(svgAsset: AppAssets.iconPoll, onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Polls are coming soon!'), duration: Duration(seconds: 2)),
            );
          }),
          SizedBox(width: 26.w),
          _ToolbarIcon(svgAsset: AppAssets.iconMapPin, onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location tagging is coming soon!'), duration: Duration(seconds: 2)),
            );
          }),
          const Spacer(),
          Text(
            '$charCount/$maxChars',
            style: TextStyle(
              fontSize: 12.5.sp,
              color: AppColors.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 26.w,
            height: 26.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 2.5,
                  color: AppColors.border,
                ),
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 2.5,
                  backgroundColor: AppColors.transparent,
                  color: charCount > 260 ? AppColors.negativeVote : AppColors.sage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final String svgAsset;
  final VoidCallback onTap;
  const _ToolbarIcon({required this.svgAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: SvgPicture.asset(svgAsset, width: 22.w, height: 22.w, colorFilter: ColorFilter.mode(AppColors.textLabel, BlendMode.srcIn)),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 24,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/size_config.dart';

/// Shared widget for rendering a single post image in a contained rounded card.
/// Used in both [PostCard] (feed) and [ThreadPost] (thread).
class PostImageContainer extends StatelessWidget {
  final String imageUrl;

  const PostImageContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          height: 210.h,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: 210.h,
            color: AppColors.borderLight,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.sage,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: 210.h,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image_outlined, size: 32.w, color: AppColors.imagePlaceholder),
                SizedBox(height: 8.h),
                Text(
                  'Image unavailable',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

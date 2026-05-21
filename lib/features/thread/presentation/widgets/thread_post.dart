import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/post_image_container.dart';
import '../../domain/entities/thread_entity.dart';

class ThreadPost extends StatelessWidget {
  final ThreadEntity thread;
  const ThreadPost({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: AppColors.postAvatarBg,
                      backgroundImage: thread.authorAvatarUrl != null
                          ? NetworkImage(thread.authorAvatarUrl!)
                          : null,
                      child: thread.authorAvatarUrl == null
                          ? Icon(Icons.person, color: Colors.white54, size: 22.w)
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thread.title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'POSTED BY ${thread.authorName.toUpperCase()} • ${thread.postedAgo}',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              color: AppColors.navInactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                // Body text
                if (thread.body.isNotEmpty)
                  Text(
                    thread.body,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.6,
                      color: AppColors.textCaption,
                    ),
                  ),
                if (thread.imageUrl != null) SizedBox(height: 14.h),
              ],
            ),
          ),
          // Contained image below the text (outside padding so it reaches card edges but clipped by border radius)
          if (thread.imageUrl != null) ...[
            PostImageContainer(imageUrl: thread.imageUrl!),
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/create_post_provider.dart';

class CreatePostHeader extends StatelessWidget {
  const CreatePostHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/feed');
              }
            },
            child: Icon(Icons.close, size: 22.w, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Create',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (provider.status == CreatePostStatus.loading) return;

              final postId = await provider.submitPost();

              if (!context.mounted) return;

              if (postId != null && provider.status == CreatePostStatus.success) {
                context.go('/thread?id=$postId');
              } else {
                final error = provider.errorMessage ?? 'An unknown error occurred';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppColors.negativeVote,
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: provider.status == CreatePostStatus.loading
                  ? SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white),
                    )
                  : Text(
                      'POST',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

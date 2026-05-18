import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../widgets/create_post_header.dart';
import '../widgets/create_post_input_card.dart';
import '../widgets/create_post_bottom_toolbar.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.borderLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CreatePostHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const CreatePostInputCard(),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
            const CreatePostBottomToolbar(),
          ],
        ),
      ),
    );
  }
}

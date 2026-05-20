import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/create_post_provider.dart';

class CreatePostInputCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const CreatePostInputCard({
    super.key,
    required this.titleController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _AvatarRow(
            titleController: titleController,
            contentController: contentController,
          ),
          SizedBox(height: 16.h),
          _FlairRow(provider: provider),
        ],
      ),
    );
  }
}

class _AvatarRow extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const _AvatarRow({
    required this.titleController,
    required this.contentController,
  });

  static InputDecoration _fieldDecoration({
    required String hint,
    required double hintSize,
    required double fontSize,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: hintSize,
          fontWeight: FontWeight.w400,
          color: AppColors.textHint,
          height: 1.35,
        ),
        filled: true,
        fillColor: Colors.transparent,
        border: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
        counterText: '',
        isDense: true,
        contentPadding: EdgeInsets.zero,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.inputBorder, width: 1.5),
            color: AppColors.avatarFallbackBg,
          ),
          child: const ClipOval(
            child: Icon(Icons.person, color: Colors.white54, size: 26),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                maxLines: null,
                maxLength: 120,
                autofocus: true,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
                decoration: _fieldDecoration(
                  hint: 'Add a title...',
                  hintSize: 17.sp,
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Divider(color: AppColors.border, height: 1, thickness: 1),
              SizedBox(height: 10.h),
              TextField(
                controller: contentController,
                maxLines: null,
                maxLength: 500,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                decoration: _fieldDecoration(
                  hint: "What's happening on campus?",
                  hintSize: 14.sp,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FlairRow extends StatelessWidget {
  final CreatePostProvider provider;
  const _FlairRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    const flairs = ['Select flair', 'Event', 'Marketplace'];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: flairs.map((flair) {
        final isSelected = provider.selectedFlair == flair;
        final isSelector = flair == 'Select flair';

        return GestureDetector(
          onTap: () {
            if (!isSelector) provider.setFlair(isSelected ? null : flair);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.sage : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: isSelected ? AppColors.sage : AppColors.inputBorder,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelector)
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Icon(
                      Icons.local_offer_outlined,
                      size: 12.w,
                      color: isSelected ? Colors.white : AppColors.textLabel,
                    ),
                  ),
                Text(
                  flair,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isSelected ? Colors.white : AppColors.textLabel,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/create_post_provider.dart';

class CreatePostInputCard extends StatelessWidget {
  final TextEditingController controller;
  const CreatePostInputCard({super.key, required this.controller});

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
          _AvatarRow(provider: provider, controller: controller),
          SizedBox(height: 16.h),
          _FlairRow(provider: provider),
        ],
      ),
    );
  }
}

class _AvatarRow extends StatelessWidget {
  final CreatePostProvider provider;
  final TextEditingController controller;
  const _AvatarRow({required this.provider, required this.controller});

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
            color: const Color(0xFF1A2C3D),
          ),
          child: const ClipOval(
            child: Icon(Icons.person, color: Colors.white54, size: 26),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: null,
            maxLength: 280,
            autofocus: false,
            style: TextStyle(
              fontSize: 17.sp,
              color: AppColors.textPrimary,
              height: 1.4,
              letterSpacing: -0.1,
            ),
            decoration: InputDecoration(
              hintText: "What's happening on campus?",
              hintMaxLines: 1,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.disabled,
                height: 1.35,
                letterSpacing: -0.2,
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
              counterText: '',
              isDense: true,
              contentPadding: EdgeInsets.only(top: 6.h),
            ),
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
    const flairs = ['SELECT FLAIR', 'EVENT', 'MARKETPLACE'];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: flairs.map((flair) {
        final isSelected = provider.selectedFlair == flair;
        final isSelector = flair == 'SELECT FLAIR';

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

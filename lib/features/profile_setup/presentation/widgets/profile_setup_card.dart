import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../domain/entities/university_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/profile_setup_provider.dart';

class ProfileSetupCard extends StatelessWidget {
  const ProfileSetupCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileSetupProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.altPageBg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepHeader(),
          SizedBox(height: 16.h),
          _ProgressBar(currentStep: 2, totalSteps: 3),
          SizedBox(height: 18.h),
          Text(
            'Tell us about\nyourself',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              height: 1.25,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'This information helps us personalize\nyour CampusOS experience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.textFaint,
            ),
          ),
          SizedBox(height: 16.h),
          _SectionLabel('PROFILE PHOTO'),
          SizedBox(height: 10.h),
          _PhotoUploadButton(
            photoBytes: provider.photoBytes,
            onTap: provider.pickImage,
          ),
          SizedBox(height: 14.h),
          _SectionLabel('FULL NAME'),
          SizedBox(height: 8.h),
          _NameField(onChanged: provider.setFullName),
          SizedBox(height: 18.h),
          _SectionLabel('UNIVERSITY'),
          SizedBox(height: 8.h),
          _UniversityDropdownField(
            hint: 'Select University',
            value: provider.selectedUniversity,
            items: provider.universities,
            onChanged: provider.setUniversity,
          ),
          SizedBox(height: 18.h),
          _SectionLabel('DEPARTMENT'),
          SizedBox(height: 8.h),
          _DropdownField(
            hint: 'Select Department',
            value: provider.selectedDepartment,
            items: provider.departments,
            onChanged: provider.setDepartment,
          ),
          SizedBox(height: 18.h),
          _SectionLabel('SEMESTER'),
          SizedBox(height: 8.h),
          _DropdownField(
            hint: 'Select Semester',
            value: provider.selectedSemester,
            items: provider.semesters,
            onChanged: provider.setSemester,
          ),
          SizedBox(height: 20.h),
          _NextStepButton(
            isLoading: provider.status == ProfileSetupStatus.loading,
            onTap: () async {
              await provider.saveProfile();
              if (context.mounted &&
                  provider.status == ProfileSetupStatus.success) {
                context.go('/feed');
              }
            },
          ),
          SizedBox(height: 12.h),
          _BackButton(onTap: () => context.go('/onboarding')),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'STEP 2 OF 3',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: AppColors.textLabel,
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: Row(
            children: [
              Text(
                'Save & Exit',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textCaption,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '✕',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textCaption),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const _ProgressBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: LinearProgressIndicator(
        value: currentStep / totalSteps,
        minHeight: 5.h,
        backgroundColor: AppColors.borderLight,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sage),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.textLabel,
        ),
      ),
    );
  }
}

class _PhotoUploadButton extends StatelessWidget {
  final Uint8List? photoBytes;
  final VoidCallback onTap;
  const _PhotoUploadButton({this.photoBytes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.borderLight,
              border: Border.all(color: AppColors.inputBorder, width: 1.5),
              image: photoBytes != null
                  ? DecorationImage(
                      image: MemoryImage(photoBytes!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photoBytes == null
                ? Icon(Icons.photo_camera_outlined, size: 28.w, color: AppColors.navInactive)
                : null,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Upload Photo',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textCaption,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'JPG, GIF or PNG. Max 800K.',
          style: TextStyle(fontSize: 11.sp, color: AppColors.navInactive),
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _NameField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Jane Doe',
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        filled: true,
        fillColor: AppColors.cardBg,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.sage, width: 1.5),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(fontSize: 14.sp, color: AppColors.textHint)),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textLabel, size: 20.w),
          isExpanded: true,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          dropdownColor: AppColors.cardBg,
          borderRadius: BorderRadius.circular(8.r),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _UniversityDropdownField extends StatelessWidget {
  final String hint;
  final UniversityEntity? value;
  final List<UniversityEntity> items;
  final ValueChanged<UniversityEntity?> onChanged;

  const _UniversityDropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UniversityEntity>(
          value: value,
          hint: Text(items.isEmpty ? 'Loading...' : hint, style: TextStyle(fontSize: 14.sp, color: AppColors.textHint)),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textLabel, size: 20.w),
          isExpanded: true,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          dropdownColor: AppColors.cardBg,
          borderRadius: BorderRadius.circular(8.r),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _NextStepButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _NextStepButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.sage,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                )
              : Text(
                  'Next Step →',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.borderLight,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            '← Back',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textCaption,
            ),
          ),
        ),
      ),
    );
  }
}

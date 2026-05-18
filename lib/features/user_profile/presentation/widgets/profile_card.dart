import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'profile_stat_item.dart';

class ProfileCard extends StatelessWidget {
  final UserProfileEntity profile;
  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 22.h),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.avatarBg,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? Text(
                        profile.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 38.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sage,
                ),
                child: Icon(Icons.edit, size: 14.w, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            '${profile.department}, ${profile.year}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: AppColors.textLabel,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              profile.bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                color: AppColors.textSubtle,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Expanded(
                child: ProfileStatItem(value: '${profile.postCount}', label: 'POSTS'),
              ),
              Container(width: 1, height: 34.h, color: AppColors.border),
              Expanded(
                child: ProfileStatItem(value: '${profile.karma}', label: 'KARMA', color: AppColors.karmaColor),
              ),
              Container(width: 1, height: 34.h, color: AppColors.border),
              Expanded(
                child: ProfileStatItem(value: '${profile.ridesCount}', label: 'RIDES'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

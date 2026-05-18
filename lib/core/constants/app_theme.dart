// Core design tokens – single source of truth.
// Import this file to get AppColors, AppTextStyles, and AppDimens.
export 'app_colors.dart';

import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TYPOGRAPHY
// ─────────────────────────────────────────────────────────────────────────────
class AppTextStyles {
  static const _inter = 'Inter';

  static const display = TextStyle(fontFamily: _inter, fontSize: 32, fontWeight: FontWeight.w900, height: 1.15, letterSpacing: -0.5, color: AppColors.textPrimary);

  static const heading1 = TextStyle(fontFamily: _inter, fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary);
  static const heading2 = TextStyle(fontFamily: _inter, fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary);
  static const heading3 = TextStyle(fontFamily: _inter, fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary);

  static const bodyLarge  = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textPrimary);
  static const bodyMedium = TextStyle(fontFamily: _inter, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
  static const bodySmall  = TextStyle(fontFamily: _inter, fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textMuted);

  static const labelCaps  = TextStyle(fontFamily: _inter, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.textLabel);
  static const labelSmall = TextStyle(fontFamily: _inter, fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textLabel);

  static const buttonPrimary  = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Colors.white);
  static const buttonOutlined = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.textPrimary);

  static const navItem  = TextStyle(fontFamily: _inter, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static const postTitle   = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w700, height: 1.3, color: AppColors.textPrimary);
  static const postExcerpt = TextStyle(fontFamily: _inter, fontSize: 13, height: 1.5, color: AppColors.textSecondary);
  static const postMeta    = TextStyle(fontFamily: _inter, fontSize: 10, letterSpacing: 0.2, color: AppColors.textMuted);
}

// ─────────────────────────────────────────────────────────────────────────────
// DIMENSIONS  (spacing, radii, fixed sizes)
// ─────────────────────────────────────────────────────────────────────────────
class AppDimens {
  static const pagePadH     = 16.0;
  static const pagePadV     = 20.0;
  static const cardPad      = 14.0;
  static const cardPadLarge = 16.0;

  static const radiusCard   = 12.0;
  static const radiusLarge  = 16.0;
  static const radiusChip   = 20.0;
  static const radiusInput  = 12.0;
  static const radiusButton = 100.0;

  static const spaceXS  = 4.0;
  static const spaceS   = 8.0;
  static const spaceM   = 12.0;
  static const spaceL   = 16.0;
  static const spaceXL  = 24.0;
  static const spaceXXL = 32.0;

  static const bottomNavHeight = 64.0;
  static const topNavPadV      = 10.0;
  static const topNavPadH      = 18.0;
  static const buttonHeight    = 54.0;
  static const accentBarHeight = 5.0;
}

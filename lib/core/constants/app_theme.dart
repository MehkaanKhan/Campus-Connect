// Core design tokens – single source of truth
// All widgets must import from here instead of hardcoding values.

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  // Backgrounds
  static const pageBg        = Color(0xFFF8FAFC);   // feed / explore / general pages
  static const onboardingBg  = Color(0xFFEEEDE4);   // onboarding / auth pages
  static const cardBg        = Colors.white;
  static const darkCardBg    = Color(0xFF2E3D2E);

  // Brand palette
  static const primary       = Color(0xFF1A1A1A);   // black – primary CTAs
  static const sage          = Color(0xFF6B8F6B);   // muted sage green – active states
  static const sageDark      = Color(0xFF3D5C3D);
  static const sageLight     = Color(0xFFE8F3E8);
  static const sageMid       = Color(0xFF7A9B7A);

  // Text
  static const textPrimary   = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted     = Color(0xFF94A3B8);
  static const textHint      = Color(0xFFAAAAAA);
  static const textCaption   = Color(0xFF555555);
  static const textLabel     = Color(0xFF888880);   // small-caps labels

  // Borders & dividers
  static const border        = Color(0xFFEEEEE8);
  static const borderLight   = Color(0xFFF0F0EC);
  static const inputBorder   = Color(0xFFDCDCD4);

  // Flair / category chips
  static const flairEvents      = Color(0xFFD6D6EA);
  static const flairAcademic    = Color(0xFFFED9B8);
  static const flairHostel      = Color(0xFFE2E3E0);
  static const flairCarpool     = Color(0xFFE2E9E0);
  static const flairMarketplace = Color(0xFFD6D6EA);

  // Leaderboard accent bars
  static const rank1Accent   = Color(0xFF7A9B7A);   // sage green  – #1
  static const rank2Accent   = Color(0xFFC8A97A);   // warm caramel – #2
  static const rank3Accent   = Color(0xFFB8B8BC);   // silver-gray  – #3

  // Leaderboard badge backgrounds
  static const rank1BadgeBg  = Color(0xFF3D5C3D);
  static const rank2BadgeBg  = Color(0xFFFAEDD6);
  static const rank3BadgeBg  = Color(0xFFEDF4E9);
  static const rank2BadgeText = Color(0xFFB07D3A);

  // Carpool
  static const carpoolMapBg  = Color(0xFFECF0E8);
  static const carpoolRoute  = Color(0xFFB0BEAA);

  // Utility
  static const error         = Color(0xFFEF4444);
  static const disabled      = Color(0xFFBBBBB8);
  static const disabledBg    = Color(0xFFF2F1EE);

  // Filter chips
  static const filterActiveBg        = Color(0xFF6B8F6B);
  static const filterInactiveBg      = Colors.white;
  static const filterInactiveBorder  = Color(0xFFDDDDD8);
  static const filterInactiveText    = Color(0xFF434942);
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPOGRAPHY
// ─────────────────────────────────────────────────────────────────────────────
class AppTextStyles {
  static const _inter = 'Inter';

  // Display / hero
  static const display = TextStyle(fontFamily: _inter, fontSize: 32, fontWeight: FontWeight.w900, height: 1.15, letterSpacing: -0.5, color: AppColors.textPrimary);

  // Section headings
  static const heading1 = TextStyle(fontFamily: _inter, fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary);
  static const heading2 = TextStyle(fontFamily: _inter, fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary);
  static const heading3 = TextStyle(fontFamily: _inter, fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary);

  // Body
  static const bodyLarge  = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textPrimary);
  static const bodyMedium = TextStyle(fontFamily: _inter, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
  static const bodySmall  = TextStyle(fontFamily: _inter, fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textMuted);

  // Labels
  static const labelCaps  = TextStyle(fontFamily: _inter, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.textLabel);
  static const labelSmall = TextStyle(fontFamily: _inter, fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textLabel);

  // Buttons
  static const buttonPrimary   = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Colors.white);
  static const buttonOutlined  = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.textPrimary);

  // Navigation
  static const navItem = TextStyle(fontFamily: _inter, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  // Feed / post
  static const postTitle   = TextStyle(fontFamily: _inter, fontSize: 15, fontWeight: FontWeight.w700, height: 1.3, color: AppColors.textPrimary);
  static const postExcerpt = TextStyle(fontFamily: _inter, fontSize: 13, height: 1.5, color: AppColors.textSecondary);
  static const postMeta    = TextStyle(fontFamily: _inter, fontSize: 10, letterSpacing: 0.2, color: AppColors.textMuted);
}

// ─────────────────────────────────────────────────────────────────────────────
// DIMENSIONS  (spacing, radii, fixed sizes)
// ─────────────────────────────────────────────────────────────────────────────
class AppDimens {
  // Page / card padding
  static const pagePadH     = 16.0;
  static const pagePadV     = 20.0;
  static const cardPad      = 14.0;
  static const cardPadLarge = 16.0;

  // Border radii
  static const radiusCard   = 12.0;
  static const radiusLarge  = 16.0;
  static const radiusChip   = 20.0;
  static const radiusInput  = 12.0;
  static const radiusButton = 100.0;

  // Common spacing
  static const spaceXS  = 4.0;
  static const spaceS   = 8.0;
  static const spaceM   = 12.0;
  static const spaceL   = 16.0;
  static const spaceXL  = 24.0;
  static const spaceXXL = 32.0;

  // Navbar
  static const bottomNavHeight = 64.0;
  static const topNavPadV      = 10.0;
  static const topNavPadH      = 18.0;

  // Buttons
  static const buttonHeight    = 54.0;

  // Accent bar (leaderboard top-3 cards)
  static const accentBarHeight = 5.0;
}

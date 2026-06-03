import 'package:flutter/material.dart';

class AppColors {
  // ── Generic / Overlays ───────────────────────────────────
  static const transparent  = Colors.transparent;
  static const white        = Colors.white;
  static const white54      = Colors.white54;
  static const white60      = Colors.white60;
  static const black        = Colors.black;
  static const black54      = Colors.black54;
  static const overlayDark  = Color(0x8A000000); // black54 equivalent

  // ── Brand ────────────────────────────────────────────────
  static const primary    = Color(0xFF3D5C3D); // brand sage green — ThemeData seed, buttons
  static const secondary  = Color(0xFF6B8F6B); // medium sage green
  static const accent     = Color(0xFFF59E0B); // amber — cart, highlights
  static const sage       = Color(0xFF6B8F6B); // sage green — active states, carpool chips
  static const sageDark   = Color(0xFF3D5C3D);
  static const sageLight  = Color(0xFFE8F3E8);
  static const sageMid    = Color(0xFF7A9B7A);

  // ── Backgrounds ──────────────────────────────────────────
  static const background    = Color(0xFFF8FAFC); // alias kept for ThemeData
  static const surface       = Colors.white;       // alias kept for ThemeData
  static const pageBg        = Color(0xFFF8FAFC);  // feed / explore / general
  static const altPageBg     = Color(0xFFF7F7F5);  // hostellite / thread
  static const onboardingBg  = Color(0xFFEEEDE4);
  static const cardBg        = Colors.white;
  static const darkCardBg    = Color(0xFF2E3D2E);

  // ── Text ─────────────────────────────────────────────────
  static const textPrimary   = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted     = Color(0xFF94A3B8);
  static const textHint      = Color(0xFFAAAAAA);
  static const textCaption   = Color(0xFF555555);
  static const textLabel     = Color(0xFF888880); // small-caps labels
  static const textSubtle    = Color(0xFF3F3F46); // bio / body copy
  static const textFaint     = Color(0xFF666660); // excerpt / secondary body

  // ── Borders & dividers ───────────────────────────────────
  static const border        = Color(0xFFEEEEE8);
  static const borderLight   = Color(0xFFF0F0EC);
  static const navBorderTop  = Color(0xFFF0F0F0); // top navbar underline
  static const inputBorder   = Color(0xFFDCDCD4);

  // ── Filter chips (hostellite / notifications style) ──────
  static const filterActiveBg       = Color(0xFF98A895);
  static const filterInactiveBg     = Color(0xFFF2F3F0);
  static const filterInactiveBorder = Color(0xFFE2E3E0);
  static const filterInactiveText   = Color(0xFF434942);

  // ── Flair / category chips ───────────────────────────────
  static const flairEvents      = Color(0xFFD6D6EA);
  static const flairAcademic    = Color(0xFFFED9B8);
  static const flairHostel      = Color(0xFFE2E3E0);
  static const flairCarpool     = Color(0xFFE2E9E0);
  static const flairMarketplace = Color(0xFFD6D6EA);
  static const flairColors = [
    Color(0xFFD6D6EA),
    Color(0xFFFED9B8),
    Color(0xFFE2E3E0),
    Color(0xFFE2E9E0),
  ];

  // ── Hostellite exchange item-type badges ─────────────────
  static const borrowBadgeBg   = Color(0xFFE3E9E1);
  static const rentBadgeBg     = Color(0xFFE5ECF0);
  static const freeBadgeBg     = Color(0xFFF1F2EF);
  static const borrowBadgeText = Color(0xFF3D483A);
  static const rentBadgeText   = Color(0xFF1D2B33);
  static const freeBadgeText   = Color(0xFF2A2E26);

  // ── Notifications ────────────────────────────────────────
  static const unreadNotifBg = Color(0xFFF0F7F0);
  static const notifIconBg   = Color(0xFFE2E9E0);

  // ── Profile ──────────────────────────────────────────────
  static const avatarBg    = Color(0xFFD6D6EA);
  static const karmaColor  = Color(0xFFA895A0);
  static const navInactive = Color(0xFF999990);

  // ── Leaderboard ──────────────────────────────────────────
  static const rank1Accent    = Color(0xFF7A9B7A);
  static const rank2Accent    = Color(0xFFC8A97A);
  static const rank3Accent    = Color(0xFFB8B8BC);
  static const rank1BadgeBg   = Color(0xFF3D5C3D);
  static const rank2BadgeBg   = Color(0xFFFAEDD6);
  static const rank3BadgeBg   = Color(0xFFEDF4E9);
  static const rank2BadgeText = Color(0xFFB07D3A);
  static const goldMedal      = Color(0xFFFFD700);
  static const silverMedal    = Color(0xFFC0C0C0);
  static const bronzeMedal    = Color(0xFFCD7F32);

  // ── Carpool ──────────────────────────────────────────────
  static const carpoolMapBg = Color(0xFFECF0E8);
  static const carpoolRoute = Color(0xFFB0BEAA);

  // ── Utility ──────────────────────────────────────────────
  static const error            = Color(0xFFEF4444);
  static const negativeVote     = Color(0xFFB85050);
  static const success          = Color(0xFF22C55E);
  static const disabled         = Color(0xFFBBBBB8);
  static const disabledBg       = Color(0xFFF2F1EE);
  static const imagePlaceholder = Color(0xFFCCCCC8);

  // ── Explore hub icons ─────────────────────────────────────────────────
  static const avatarBlueBg        = Color(0xFFE8EDF8); // light indigo bg — project partners, leaderboard avatars
  static const iconTaupe           = Color(0xFFB0A890); // muted taupe — leaderboard icon
  static const iconGold            = Color(0xFFD6B26A); // warm gold — uni graph icon
  static const iconCreamBg         = Color(0xFFF9F5EC); // warm cream bg — uni graph icon
  static const iconBlue            = Color(0xFF6A98D6); // medium blue — other unis icon
  static const iconBlueBg          = Color(0xFFECF3F9); // light blue bg — other unis icon

  // ── Project partner badges ────────────────────────────────────────────
  static const badgeStartupText    = Color(0xFFC8913A); // warm amber text — startup idea
  static const badgeStartupBg      = Color(0xFFFDF3E6); // pale amber bg — startup idea
  static const badgeHackathonText  = Color(0xFF5A7FA8); // steel blue text — hackathon
  static const badgeHackathonBg    = Color(0xFFEAF1F8); // pale blue bg — hackathon
  static const badgeDefaultBg      = Color(0xFFEDF4ED); // pale green bg — default project badge

  // ── Thread / comment avatars ──────────────────────────────────────────
  static const commentAvatarBg       = Color(0xFF6B5A8A); // purple — top-level comment avatar
  static const commentNestedAvatarBg = Color(0xFF3C5A8A); // navy — nested comment avatar
  static const postAvatarBg          = Color(0xFF2C3E35); // dark forest green — thread post avatar
  static const avatarFallbackBg      = Color(0xFF1A2C3D); // dark navy — create-post placeholder avatar

  // ── Leaderboard extras ────────────────────────────────────────────────
  static const sageGradientEnd   = Color(0xFFB0CFAE); // light sage — leaderboard header gradient end
  static const listItemBorder    = Color(0xFFF2F2F0); // list item separator border
  static const navyBlue          = Color(0xFF1E3A8A); // dark navy — rank avatar inner circle
  static const scoreBlue         = Color(0xFF3B82F6); // bright blue — leaderboard score points

  // ── Graph / network ───────────────────────────────────────────────────
  static const graphEdge = Color(0xFFCBD5E1); // slate-300 — graph edge lines, theme input border

  // ── Uni profile page ─────────────────────────────────────────────────
  static const textDark       = Color(0xFF1A1C19); // dark greenish-black — uni profile headings
  static const avatarWarmGray = Color(0xFFEBEBE8); // warm light gray — uni profile avatar placeholder

  // ── Misc ──────────────────────────────────────────────────────────────
  static const borderSlate    = Color(0xFFE2E8F0); // slate border — form inputs, item detail
  static const setupPageBg    = Color(0xFF1C1C1C); // near-black — profile setup page background
  static const borderGrayGreen = Color(0xFFC3C8BC); // gray-green — uni overlay modal border
}

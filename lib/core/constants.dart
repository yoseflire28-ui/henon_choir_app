import 'package:flutter/material.dart';

/// App-wide constants for colors, dimensions, strings, and shared values.
abstract class AppConstants {
  // ─── Brand Colors ─────────────────────────────────────────────────────────
  static const Color deepNavy = Color(0xFF0D0B26);
  static const Color darkNavy = Color(0xFF060515);
  static const Color accentCrimson = Color(0xFFC81D25);
  static const Color crimsonLight = Color(0xFFE8232C);
  static const Color crimsonDark = Color(0xFF9A1018);

  // ─── Light Theme Palette ──────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color lightSearchBar = Color(0xFFF1F3F5);

  // ─── Dark Theme Palette ───────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCardColor = Color(0xFF1E1E2E);
  static const Color darkCardElevated = Color(0xFF252540);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B3C1);
  static const Color darkDivider = Color(0xFF2A2A3E);
  static const Color darkSearchBar = Color(0xFF1E1E2E);

  // ─── Spacing ──────────────────────────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ─── Border Radius ────────────────────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // ─── Typography Sizes ─────────────────────────────────────────────────────
  static const double fontXs = 11.0;
  static const double fontSm = 13.0;
  static const double fontMd = 15.0;
  static const double fontLg = 17.0;
  static const double fontXl = 20.0;
  static const double fontXxl = 26.0;
  static const double fontDisplay = 32.0;

  // ─── Default Song Detail Font Size ────────────────────────────────────────
  static const double defaultLyricFontSize = 16.0;
  static const double minLyricFontSize = 12.0;
  static const double maxLyricFontSize = 28.0;

  // ─── Asset Paths ──────────────────────────────────────────────────────────
  static const String songsJsonPath = 'assets/data/songs.json';

  // ─── SharedPreferences Keys ───────────────────────────────────────────────
  static const String prefKeyDarkMode = 'isDarkMode';
  static const String prefKeyFavorites = 'favorite_songs';

  // ─── App Strings ──────────────────────────────────────────────────────────
  static const String appName = 'Yehenon Choir YeMezmur Debter';
  static const String appNameAmharic = 'የሄኖን መዘምራን የመዝሙር ደብተር';
  static const String appDisplayName = 'HENON CHOIR';
  static const String appVersion = 'Version 1.0.1';

  // ─── Navigation Labels ────────────────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navAllSongs = 'All Songs';
  static const String navFavorites = 'Favorites';
  static const String navSettings = 'Settings';

  // ─── Splash ───────────────────────────────────────────────────────────────
  static const Duration splashDuration = Duration(milliseconds: 2500);

  // ─── Animation Durations ─────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // ─── Card Elevation ───────────────────────────────────────────────────────
  static const double cardElevationLight = 2.0;
  static const double cardElevationDark = 0.0;

  // ─── Bottom Nav Bar Height ────────────────────────────────────────────────
  static const double bottomNavBarHeight = 60.0;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

/// Centralised theme configuration for the application.
/// Supports both light and dark modes with a consistent Amharic/Ethiopic
/// typography stack via Noto Sans Ethiopic from Google Fonts.
abstract class AppTheme {
  // ─── Shared text theme builder ─────────────────────────────────────────
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    // Noto Sans Ethiopic renders Amharic/Ethiopic glyphs; fall back to
    // NotoSans for Latin characters in the same style.
    final base = GoogleFonts.notoSansEthiopicTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontDisplay,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: primary,
          height: 1.25,
        ),
        displayMedium: TextStyle(
          fontSize: AppConstants.fontXxl,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: primary,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          fontSize: AppConstants.fontXl,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: primary,
          height: 1.35,
        ),
        headlineMedium: TextStyle(
          fontSize: AppConstants.fontLg,
          fontWeight: FontWeight.w600,
          color: primary,
          height: 1.4,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.fontLg,
          fontWeight: FontWeight.w600,
          color: primary,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: AppConstants.fontMd,
          fontWeight: FontWeight.w500,
          color: primary,
          height: 1.45,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontMd,
          fontWeight: FontWeight.w400,
          color: primary,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSm,
          fontWeight: FontWeight.w400,
          color: secondary,
          height: 1.55,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontXs,
          fontWeight: FontWeight.w400,
          color: secondary,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: AppConstants.fontSm,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: primary,
        ),
        labelMedium: TextStyle(
          fontSize: AppConstants.fontXs,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: secondary,
        ),
      ),
    );
    return base;
  }

  // ─── Light Theme ───────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const primary = AppConstants.lightTextPrimary;
    const secondary = AppConstants.lightTextSecondary;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppConstants.accentCrimson,
        onPrimary: Colors.white,
        secondary: AppConstants.deepNavy,
        onSecondary: Colors.white,
        surface: AppConstants.lightSurface,
        onSurface: primary,
        error: Color(0xFFB00020),
        onError: Colors.white,
        outline: AppConstants.lightDivider,
        surfaceContainerHighest: AppConstants.lightSearchBar,
      ),
      scaffoldBackgroundColor: AppConstants.lightBackground,
      textTheme: _buildTextTheme(primary, secondary),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.lightSurface,
        foregroundColor: primary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppConstants.lightDivider,
        titleTextStyle: GoogleFonts.notoSansEthiopic(
          fontSize: AppConstants.fontLg,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        iconTheme: const IconThemeData(color: primary),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppConstants.lightCardColor,
        elevation: AppConstants.cardElevationLight,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.lightSurface,
        selectedItemColor: AppConstants.accentCrimson,
        unselectedItemColor: AppConstants.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontXs,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontXs,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Input / Search
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.lightSearchBar,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          borderSide: const BorderSide(
            color: AppConstants.accentCrimson,
            width: 1.5,
          ),
        ),
        hintStyle: const TextStyle(
          color: secondary,
          fontSize: AppConstants.fontMd,
        ),
        prefixIconColor: secondary,
        suffixIconColor: secondary,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConstants.accentCrimson;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConstants.accentCrimson.withValues(alpha: 0.4);
          }
          return AppConstants.lightDivider;
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppConstants.lightDivider,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: primary,
        size: 22,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.accentCrimson,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  // ─── Dark Theme ────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const primary = AppConstants.darkTextPrimary;
    const secondary = AppConstants.darkTextSecondary;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.accentCrimson,
        onPrimary: Colors.white,
        secondary: AppConstants.accentCrimson,
        onSecondary: Colors.white,
        surface: AppConstants.darkSurface,
        onSurface: primary,
        error: Color(0xFFCF6679),
        onError: Colors.black,
        outline: AppConstants.darkDivider,
        surfaceContainerHighest: AppConstants.darkSearchBar,
      ),
      scaffoldBackgroundColor: AppConstants.darkBackground,
      textTheme: _buildTextTheme(primary, secondary),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.darkSurface,
        foregroundColor: primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.notoSansEthiopic(
          fontSize: AppConstants.fontLg,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        iconTheme: const IconThemeData(color: primary),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppConstants.darkCardColor,
        elevation: AppConstants.cardElevationDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.darkSurface,
        selectedItemColor: AppConstants.accentCrimson,
        unselectedItemColor: AppConstants.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontXs,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontXs,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Input / Search
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.darkSearchBar,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          borderSide: const BorderSide(
            color: AppConstants.accentCrimson,
            width: 1.5,
          ),
        ),
        hintStyle: const TextStyle(
          color: secondary,
          fontSize: AppConstants.fontMd,
        ),
        prefixIconColor: secondary,
        suffixIconColor: secondary,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConstants.accentCrimson;
          }
          return AppConstants.darkTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConstants.accentCrimson.withValues(alpha: 0.4);
          }
          return AppConstants.darkDivider;
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppConstants.darkDivider,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: primary,
        size: 22,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.accentCrimson,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}

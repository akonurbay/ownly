import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
        surface: AppColors.bgPrimary,
        onSurface: AppColors.textPrimary,
        primary: AppColors.accent,
        onPrimary: Colors.white,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgPrimary,
      cardColor: AppColors.bgCard,
      dividerColor: AppColors.border,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        bodyMedium: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgCard,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.textSub,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.accent.withValues(alpha: 0.27),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          minimumSize: const Size(double.infinity, 52),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

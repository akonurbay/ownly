import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(OwnlyColors.light, Brightness.light);
  static ThemeData get dark  => _build(OwnlyColors.dark,  Brightness.dark);

  static ThemeData _build(OwnlyColors c, Brightness brightness) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: brightness,
        surface: c.bgPrimary,
        onSurface: c.textPrimary,
        primary: AppColors.accent,
        onPrimary: Colors.white,
      ),
    );

    return base.copyWith(
      extensions: [c],
      scaffoldBackgroundColor: c.bgPrimary,
      cardColor: c.bgCard,
      dividerColor: c.border,
      dialogTheme: DialogThemeData(backgroundColor: c.bgCard),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        bodyMedium: GoogleFonts.inter(color: c.textPrimary, fontSize: 14),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bgPrimary,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.bgCard,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: c.textMuted,
        selectedLabelStyle:
            GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.bgCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: c.textMuted, fontSize: 14),
        labelStyle: GoogleFonts.inter(
            color: c.textSub, fontSize: 12, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.accent.withValues(alpha: 0.27),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999)),
          minimumSize: const Size(double.infinity, 52),
          textStyle: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

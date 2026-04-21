import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display (Lora serif)
  static TextStyle get h1 => GoogleFonts.lora(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => GoogleFonts.lora(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get h3 => GoogleFonts.lora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get h4 => GoogleFonts.lora(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get quote => GoogleFonts.lora(
        fontSize: 14,
        fontStyle: FontStyle.italic,
        color: AppColors.textSub,
      );

  static TextStyle get cardTitle => GoogleFonts.lora(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardTitleSm => GoogleFonts.lora(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Interface (Inter sans-serif)
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSub,
      );

  static TextStyle get micro => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.08 * 11,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSub,
      );
}

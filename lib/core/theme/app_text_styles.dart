import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}

class AppTS {
  final OwnlyColors _c;
  const AppTS(this._c);

  TextStyle get h1 => GoogleFonts.lora(
        fontSize: 26, fontWeight: FontWeight.w700, color: _c.textPrimary);
  TextStyle get h2 => GoogleFonts.lora(
        fontSize: 22, fontWeight: FontWeight.w700, color: _c.textPrimary);
  TextStyle get h3 => GoogleFonts.lora(
        fontSize: 18, fontWeight: FontWeight.w600, color: _c.textPrimary);
  TextStyle get h4 => GoogleFonts.lora(
        fontSize: 16, fontWeight: FontWeight.w600, color: _c.textPrimary);
  TextStyle get quote => GoogleFonts.lora(
        fontSize: 14, fontStyle: FontStyle.italic, color: _c.textSub);
  TextStyle get cardTitle => GoogleFonts.lora(
        fontSize: 15, fontWeight: FontWeight.w600, color: _c.textPrimary);
  TextStyle get cardTitleSm => GoogleFonts.lora(
        fontSize: 14, fontWeight: FontWeight.w600, color: _c.textPrimary);
  TextStyle get body => GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: _c.textPrimary);
  TextStyle get label => GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w500, color: _c.textPrimary);
  TextStyle get caption => GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, color: _c.textSub);
  TextStyle get micro => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: _c.textMuted,
        letterSpacing: 0.88);
  TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w400, color: _c.textSub);
}

extension ContextTS on BuildContext {
  AppTS get ts => AppTS(oc);
}

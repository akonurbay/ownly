import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Accent (terracotta — same in both themes)
  static const accent = Color(0xFFC4875A);
  static const accentDark = Color(0xFF9E6340);
  static const accentBg = Color(0xFFF5E8DC);

  // Category identity colors (static — used in enums, charts, badges)
  static const gold = Color(0xFFC49A3C);
  static const goldBg = Color(0xFFFAF3E0);
  static const green = Color(0xFF7A9E7E);
  static const greenBg = Color(0xFFEBF4EC);
  static const blue = Color(0xFF6B8CAE);
  static const blueBg = Color(0xFFE8EFF6);
  static const purple = Color(0xFF9B7BB8);
  static const purpleBg = Color(0xFFF0EAF7);

  // Semantic (same in both themes)
  static const toggleActive = Color(0xFF34C759);
  static const dangerRed = Color(0xFFFF3B30);
  static const moodBad = Color(0xFFE07070);
}

/// Theme-sensitive color palette. Use via `context.oc`.
class OwnlyColors extends ThemeExtension<OwnlyColors> {
  final Color bgPrimary;
  final Color bgDeep;
  final Color bgCard;
  final Color surface;
  final Color border;
  final Color borderSub;
  final Color textPrimary;
  final Color textSub;
  final Color textMuted;
  final Color accentBg;
  final Color goldBg;

  const OwnlyColors({
    required this.bgPrimary,
    required this.bgDeep,
    required this.bgCard,
    required this.surface,
    required this.border,
    required this.borderSub,
    required this.textPrimary,
    required this.textSub,
    required this.textMuted,
    required this.accentBg,
    required this.goldBg,
  });

  static const light = OwnlyColors(
    bgPrimary:   Color(0xFFF7F2EA),
    bgDeep:      Color(0xFFEDE6D9),
    bgCard:      Color(0xFFFFFCF7),
    surface:     Color(0xFFF2EBE0),
    border:      Color(0xFFE0D6C8),
    borderSub:   Color(0xFFEDE6D9),
    textPrimary: Color(0xFF2C2416),
    textSub:     Color(0xFF7A6A54),
    textMuted:   Color(0xFFAFA090),
    accentBg:    Color(0xFFF5E8DC),
    goldBg:      Color(0xFFFAF3E0),
  );

  static const dark = OwnlyColors(
    bgPrimary:   Color(0xFF1A1713),
    bgDeep:      Color(0xFF120F0C),
    bgCard:      Color(0xFF252019),
    surface:     Color(0xFF1E1B16),
    border:      Color(0xFF38302A),
    borderSub:   Color(0xFF2D2820),
    textPrimary: Color(0xFFEDE8DF),
    textSub:     Color(0xFFA09080),
    textMuted:   Color(0xFF665E55),
    accentBg:    Color(0xFF2C1F17),
    goldBg:      Color(0xFF26210F),
  );

  @override
  OwnlyColors copyWith({
    Color? bgPrimary,
    Color? bgDeep,
    Color? bgCard,
    Color? surface,
    Color? border,
    Color? borderSub,
    Color? textPrimary,
    Color? textSub,
    Color? textMuted,
    Color? accentBg,
    Color? goldBg,
  }) =>
      OwnlyColors(
        bgPrimary:   bgPrimary   ?? this.bgPrimary,
        bgDeep:      bgDeep      ?? this.bgDeep,
        bgCard:      bgCard      ?? this.bgCard,
        surface:     surface     ?? this.surface,
        border:      border      ?? this.border,
        borderSub:   borderSub   ?? this.borderSub,
        textPrimary: textPrimary ?? this.textPrimary,
        textSub:     textSub     ?? this.textSub,
        textMuted:   textMuted   ?? this.textMuted,
        accentBg:    accentBg    ?? this.accentBg,
        goldBg:      goldBg      ?? this.goldBg,
      );

  @override
  OwnlyColors lerp(OwnlyColors? other, double t) {
    if (other is! OwnlyColors) return this;
    return OwnlyColors(
      bgPrimary:   Color.lerp(bgPrimary,   other.bgPrimary,   t)!,
      bgDeep:      Color.lerp(bgDeep,      other.bgDeep,      t)!,
      bgCard:      Color.lerp(bgCard,      other.bgCard,      t)!,
      surface:     Color.lerp(surface,     other.surface,     t)!,
      border:      Color.lerp(border,      other.border,      t)!,
      borderSub:   Color.lerp(borderSub,   other.borderSub,   t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSub:     Color.lerp(textSub,     other.textSub,     t)!,
      textMuted:   Color.lerp(textMuted,   other.textMuted,   t)!,
      accentBg:    Color.lerp(accentBg,    other.accentBg,    t)!,
      goldBg:      Color.lerp(goldBg,      other.goldBg,      t)!,
    );
  }
}

extension OwnlyColorsExt on BuildContext {
  OwnlyColors get oc =>
      Theme.of(this).extension<OwnlyColors>() ?? OwnlyColors.light;
}

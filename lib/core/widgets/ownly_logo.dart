import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class OwnlyLogo extends StatelessWidget {
  final double size;
  final double radius;

  const OwnlyLogo({super.key, this.size = 32, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Text(
        'O',
        style: GoogleFonts.lora(
          color: Colors.white,
          fontSize: size * 0.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

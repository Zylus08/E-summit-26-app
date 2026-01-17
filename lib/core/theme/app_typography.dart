import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Headings: Space Grotesk or Sora Semi-Bold
  static TextStyle get heading1 => GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w600, // Semi-Bold
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => GoogleFonts.spaceGrotesk(
        fontSize: 24, // Header title
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading3 => GoogleFonts.spaceGrotesk(
        fontSize: 18, // Section title
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Body: Inter
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14, // Body
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // Numerical: JetBrains Mono
  static TextStyle get monoLarge => GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryAccent,
      );

  static TextStyle get monoMedium => GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );
      
  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );
      
  // Button Text
  static TextStyle get buttonText => GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}

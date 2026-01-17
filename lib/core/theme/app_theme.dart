import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkContrast,
      primaryColor: AppColors.primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.darkContrast,
        onPrimary: AppColors.white,
        onSecondary: AppColors.darkContrast,
        onSurface: AppColors.white,
        tertiary: AppColors.brandBlue,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkContrast,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.heading2,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.heading1,
        displayMedium: AppTypography.heading2,
        displaySmall: AppTypography.heading3,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.buttonText,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.buttonText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 56), // Button height: 56px
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandBlue,
          side: const BorderSide(color: AppColors.brandBlue, width: 1.5),
          textStyle: AppTypography.buttonText.copyWith(color: AppColors.brandBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandBlue,
          textStyle: AppTypography.buttonText.copyWith(color: AppColors.brandBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.supportBlue.withOpacity(0.1), // Subtle background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.supportBlue,
        thickness: 0.5,
      ),
    );
  }
}

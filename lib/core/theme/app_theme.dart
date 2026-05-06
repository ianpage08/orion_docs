import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gradientStart,
          secondary: AppColors.gradientMid,
          tertiary: AppColors.gradientEnd,
          surface: Color(0xFF111827),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.gradientStart,
          secondary: AppColors.gradientMid,
          tertiary: AppColors.gradientEnd,
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      );
}

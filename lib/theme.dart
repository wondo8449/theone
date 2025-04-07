import 'package:flutter/material.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: AppColors.grayScale_050),
    useMaterial3: true,
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: AppColors.grayScale_050,
    highlightColor: AppColors.primary_450,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary_450),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size.fromHeight(40),
        backgroundColor: AppColors.primary_450,
        foregroundColor: Colors.white,
        textStyle: AppTypography.buttonLabelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        )
      )
    )
  );
}
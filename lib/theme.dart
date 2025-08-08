import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.color1,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // iOS에서는 투명
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // iOS용
          systemNavigationBarColor: AppColors.color1,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      useMaterial3: true,
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: AppColors.color1, // color1으로 변경
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
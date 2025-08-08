import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theone/core/constants/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // iOS용
        systemNavigationBarColor: AppColors.color1,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.color1,
        body: Center(
          child: Text(
            'THE ONE',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.color2,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
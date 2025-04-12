import 'package:flutter/material.dart';
import 'package:theone/core/constants/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'THE ONE',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.primary_450,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}

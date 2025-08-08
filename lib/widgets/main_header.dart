import 'package:flutter/material.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';

class MainHeader extends StatelessWidget {
  final int selectedIndex;

  const MainHeader({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      color: AppColors.color1,
      child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: selectedIndex == 0
            ? Text(
                'THE ONE',
                style: AppTypography.headline1.copyWith(color: AppColors.color2)
              )
              : Text(
                _getPageTitle(selectedIndex),
                style: AppTypography.headline3.copyWith(
                  color: AppColors.color2,
                ),
              ),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 1:
        return "풍삶초 관리";
      case 2:
        return "나무 관리";
      case 3:
        return "마이페이지";
      default:
        return "";
    }
  }
}
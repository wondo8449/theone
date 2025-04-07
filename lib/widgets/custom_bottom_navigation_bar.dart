import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final BuildContext context;
  final WidgetRef ref;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.context,
    required this.ref
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded, color:AppColors.grayScale_550),
          activeIcon: Icon(Icons.menu_book_rounded, color:AppColors.primary_450),
          label: '나눔',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email_outlined, color:AppColors.grayScale_550),
          activeIcon: Icon(Icons.email_outlined, color:AppColors.primary_450),
          label: '풍삶초 관리',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.eco_outlined, color:AppColors.grayScale_550),
          activeIcon: Icon(Icons.eco_outlined, color:AppColors.primary_450),
          label: '나무 관리',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color:AppColors.grayScale_550),
          activeIcon: Icon(Icons.person, color:AppColors.primary_450),
          label: '마이페이지',
        )
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);
      },
      showUnselectedLabels: false,
      showSelectedLabels: false,
      type: BottomNavigationBarType.fixed
    );
  }
}
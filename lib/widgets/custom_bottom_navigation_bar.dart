
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.color6.withOpacity(0.2),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 4), // 패딩 줄여서 더 넓은 터치 영역 확보
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.menu_book_rounded, '나눔'),
              _buildNavItem(1, Icons.email_outlined, '풍삶초'),
              _buildNavItem(2, Icons.eco_outlined, '나무'),
              _buildNavItem(3, Icons.person_outline, '마이'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;

    return Expanded( // Expanded로 각 아이템이 동일한 폭을 가지도록
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        child: Container(
          // 더 넓은 터치 영역을 위해 전체 영역 사용
          margin: EdgeInsets.symmetric(horizontal: 2), // 아이템 간 최소 여백
          padding: EdgeInsets.symmetric(vertical: 8), // 상하 패딩만
          child: Container(
            // 선택된 상태의 배경 컨테이너
            padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 24 : 12, // 선택시 좌우 패딩 더 크게
                vertical: 6
            ),
            decoration: isSelected
                ? BoxDecoration(
              color: AppColors.color2,
              borderRadius: BorderRadius.circular(25), // 둥근 정도 증가
            )
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.color3,
                  size: 24,
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: isSelected ? Colors.white : AppColors.color3,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
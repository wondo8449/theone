import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import '../data/auth_api.dart';

class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    // 정규식 검증
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{9,}$');
    if (!passwordRegex.hasMatch(newPass)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("비밀번호는 숫자, 문자, 특수문자를 포함한 9자 이상이어야 합니다."),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // 비밀번호 확인 일치 체크
    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("새 비밀번호가 일치하지 않습니다."),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(authApiProvider).changePassword(current, newPass);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("비밀번호가 변경되었습니다."),
          backgroundColor: AppColors.color4,
        ),
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("현재 비밀번호가 일치하지 않습니다."),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  String _extractErrorMessage(dynamic error) {
    try {
      final json = jsonDecode(error.toString());
      return json['message'] ?? '비밀번호 변경 실패';
    } catch (_) {
      return error.toString().replaceAll("Exception: ", "").trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final token = authState['token'];
    final role = authState['role'];

    String loginId = "";
    if (token != null && token.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        loginId = decodedToken['sub'] ?? "";
      } catch (e) {
        loginId = "토큰 오류";
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 사용자 정보 카드
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.color6.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.color5,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.color3,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    loginId,
                    style: AppTypography.headline4.copyWith(
                      color: AppColors.color2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.color5,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      role ?? '',
                      style: AppTypography.body3.copyWith(
                        color: AppColors.color3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 비밀번호 변경 카드
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.color6.withOpacity(0.2),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '비밀번호 변경',
                    style: AppTypography.headline5.copyWith(
                      color: AppColors.color2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildPasswordField(
                    controller: _currentPasswordController,
                    label: '현재 비밀번호',
                    hint: '현재 사용중인 비밀번호를 입력하세요',
                  ),
                  SizedBox(height: 16),

                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: '새 비밀번호',
                    hint: '숫자, 문자, 특수문자 포함 9자 이상',
                  ),
                  SizedBox(height: 16),

                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: '새 비밀번호 확인',
                    hint: '새 비밀번호를 다시 입력하세요',
                  ),
                  SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.color4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: _changePassword,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '비밀번호 변경하기',
                        style: AppTypography.buttonLabelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 로그아웃 카드
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.color6.withOpacity(0.2),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.red,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: AppColors.red),
                    SizedBox(width: 8),
                    Text(
                      '로그아웃',
                      style: AppTypography.buttonLabelMedium.copyWith(
                        color: AppColors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40), // 하단 여백
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body2.copyWith(
            color: AppColors.color3,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          style: AppTypography.body1.copyWith(color: AppColors.color2),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body2.copyWith(color: AppColors.color3),
            filled: true,
            fillColor: AppColors.color5,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.color2, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
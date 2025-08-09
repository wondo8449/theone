import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import 'package:theone/features/auth/data/auth_api.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final authApi = ref.read(authApiProvider);

    try {
      print('로그인 시도');
      await authApi.login(
        ref,
        _usernameController.text,
        _passwordController.text,
      );

      final authState = ref.read(authProvider);
      final isAccepted = authState['isAccepted'];
      print('isAccepted : ' + isAccepted!);

      if (isAccepted == "false") {
        Navigator.pushReplacementNamed(context, '/accepted');
      } else {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: 아이디 또는 비밀번호를 확인하세요.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        title: Text(
          '로그인',
          style: AppTypography.headline3.copyWith(color: AppColors.color2),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 입력 필드 영역
              Container(
                padding: EdgeInsets.all(24),
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
                  children: [
                    TextField(
                      controller: _usernameController,
                      style: AppTypography.body1.copyWith(color: AppColors.color2),
                      decoration: InputDecoration(
                        labelText: '아이디',
                        labelStyle: AppTypography.body2.copyWith(color: AppColors.color3),
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
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: AppTypography.body1.copyWith(color: AppColors.color2),
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        labelStyle: AppTypography.body2.copyWith(color: AppColors.color3),
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
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: _handleLogin,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '로그인',
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
            ],
          ),
        ),
      ),
    );
  }
}
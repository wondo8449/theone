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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}

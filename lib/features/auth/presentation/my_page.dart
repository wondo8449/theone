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
        const SnackBar(content: Text("비밀번호는 숫자, 문자, 특수문자를 포함한 9자 이상이어야 합니다.")),
      );
      return;
    }

    // 비밀번호 확인 일치 체크
    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("새 비밀번호가 일치하지 않습니다.")),
      );
      return;
    }

    try {
      await ref.read(authApiProvider).changePassword(current, newPass);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("비밀번호가 변경되었습니다.")),
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      // 에러 메시지 파싱해서 보여주기
      final errorMessage = _extractErrorMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("현재 비밀번호가 일치하지 않습니다.")),
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
      child: Padding(
        padding: AppSpacing.medium16,
        child: ListView(
          children: [
            Text('이름 : $loginId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('권한 : $role', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Divider(height: 40),
            Text('비밀번호 변경', style: AppTypography.headline5),
            const SizedBox(height: 10),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '현재 비밀번호'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '새 비밀번호'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '새 비밀번호 확인'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('비밀번호 변경하기'),
            ),
            const Divider(height: 40),
            Padding(
              padding: AppSpacing.medium16,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('로그아웃'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Padding(
      padding: AppSpacing.medium16,
      child: ListView(
        children: [
          Text(
            '이름 : $loginId',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '권한 : $role',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
              padding: AppSpacing.medium16,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('로그아웃'),
              ),
          )
        ],
      ),
    );
  }
}

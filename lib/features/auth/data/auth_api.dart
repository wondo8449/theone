import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/api_client.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import '../../../core/api_client_provider.dart';

class AuthApi {
  final ApiClient apiClient;

  AuthApi(this.apiClient);

  Future<void> login(WidgetRef ref, String username, String password) async {
    try {
      final response = await apiClient.rawPost('/login', {
        'loginId': username,
        'password': password,
      });

      final authHeader = response.headers['authorization'];
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final data = decodedResponse['data'];

      final isAccepted = data['termsAccepted'];
      final tree = data['tree'] ?? ''; // tree 정보 추가

      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);
        ref.read(authProvider.notifier).login(token, isAccepted, tree);
      } else {
        throw Exception('토큰이 응답 헤더에 없습니다.');
      }
    } catch (e) {
      print('error : ' + e.toString());
      throw Exception('로그인 실패');
    }
  }

  Future<void> accept() async {
    final responseRaw = await apiClient.request('POST', '/user/terms', {'isAccepted': true});
    if(responseRaw.statusCode != 200) {
      throw Exception('동의 실패');
    }
  }

  Future<void> changePassword(String nowPw, String newPw) async {
    final responseRaw = await apiClient.request(
      'PATCH',
      '/user/changePassword',
      {'nowPassword': nowPw, 'newPassword': newPw},
    );

    if (responseRaw.statusCode != 200) {
      try {
        final decoded = jsonDecode(utf8.decode(responseRaw.bodyBytes));
        final message = decoded['message'] ?? '비밀번호 변경 실패';
        throw Exception(message);
      } catch (_) {
        throw Exception('비밀번호 변경 실패');
      }
    }
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApi(apiClient);
});
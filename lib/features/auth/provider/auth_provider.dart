import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthNotifier extends StateNotifier<Map<String, String?>> {
  final storage = const FlutterSecureStorage();

  AuthNotifier() : super({'token': "", 'role': ""}) {
    _loadTokenAndRole();
  }

  Future<void> _loadTokenAndRole() async {
    final token = await storage.read(key: 'accessToken');
    if (token != null && token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      final role = decodedToken['role'] ?? '';  // 'role' claim을 추출
      state = {'token': token, 'role': role};  // 상태에 토큰과 role 저장
    } else {
      state = {'token': "", 'role': ""};  // 토큰이 없으면 빈 값으로 상태 설정
    }
  }

  Future<void> login(String token) async {
    await storage.write(key: 'accessToken', value: token);
    final decodedToken = JwtDecoder.decode(token);
    final role = decodedToken['role'] ?? '';
    state = {'token': token, 'role': role};
  }

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    state = {'token': "", 'role': ""};
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Map<String, String?>>((ref) {
  return AuthNotifier();
});

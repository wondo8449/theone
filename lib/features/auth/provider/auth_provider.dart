import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthNotifier extends StateNotifier<Map<String, String?>> {
  final storage = const FlutterSecureStorage();

  AuthNotifier() : super({'token': "", 'role': "", 'loginId': "", 'isAccepted': ""}) {
    _loadTokenAndRole();
  }

  Future<void> _loadTokenAndRole() async {
    final token = await storage.read(key: 'accessToken');
    final isAccepted = await storage.read(key: 'isAccepted');
    if (token != null && token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      final role = decodedToken['role'] ?? '';
      final loginId = decodedToken['sub'] ?? "";
      print('_loadTokenAndRole - isAccepted : ' + isAccepted.toString());
      state = {'token': token, 'role': role, 'loginId': loginId, 'isAccepted': isAccepted};
    } else {
      state = {'token': "", 'role': "", 'loginId': "", 'isAccepted': ""};
    }
  }

  Future<void> login(String token, bool isAccepted) async {
    await storage.write(key: 'accessToken', value: token);
    await storage.write(key: 'isAccepted', value: isAccepted.toString());
    final decodedToken = JwtDecoder.decode(token);
    final role = decodedToken['role'] ?? '';
    final loginId = decodedToken['sub'] ?? "";

    state = {'token': token, 'role': role, 'loginId': loginId, 'isAccepted': isAccepted.toString()};
  }

  Future<void> accept() async {
    await storage.write(key: 'isAccepted', value: "true");
    state = {...state, 'isAccepted': "true"};
  }

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    state = {'token': "", 'role': "", 'loginId': "", 'isAccepted': ""};
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // TODO: 실제 API 요청 보내는 로직 작성 (예: Dio 등)
    // 임시 예시
    print('비밀번호 변경 요청: 현재=$currentPassword, 새비밀번호=$newPassword');
    await Future.delayed(const Duration(seconds: 1));
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Map<String, String?>>((ref) {
  return AuthNotifier();
});


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/features/auth/data/auth_api.dart';

class AuthRepository {
  final AuthApi authApi;
  AuthRepository(this.authApi);

  Future<void> login(WidgetRef ref, String username, String password) async {
    await authApi.login(ref, username, password);
  }

  Future<void> accept() async {
    await authApi.accept();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApi = ref.watch(authApiProvider);
  return AuthRepository(authApi);
});

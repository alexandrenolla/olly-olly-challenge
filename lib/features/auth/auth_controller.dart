import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      state = AuthState.authenticated(email);
    } else {
      state = const AuthState.error('Invalid credentials');
    }
  }

  void logout() {
    state = const AuthState.initial();
  }
} 
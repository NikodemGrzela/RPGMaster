import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Provider dla AuthService (logika Firebase)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// StreamProvider — służy do nasłuchiwania zmian stanu logowania
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider do logowania / rejestracji / wylogowania
final authControllerProvider = Provider<AuthController>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});

class AuthController {
  final AuthService _authService;
  AuthController(this._authService);

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }
}


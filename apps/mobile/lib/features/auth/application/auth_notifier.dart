import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.loading());

  final AuthRepository _repository;

  Future<void> bootstrap() async {
    final user = await _repository.bootstrapSession();
    state = user != null ? AuthState.authenticated(user) : const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    final user = await _repository.login(email, password);
    state = AuthState.authenticated(user);
  }

  Future<void> register(String email, String password, String displayName) async {
    final user = await _repository.register(email, password, displayName);
    state = AuthState.authenticated(user);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> logoutAllDevices() async {
    await _repository.logoutAllDevices();
    state = const AuthState.unauthenticated();
  }

  Future<void> deleteAccount(String password) async {
    await _repository.deleteAccount(password);
    state = const AuthState.unauthenticated();
  }

  /// Called by [ApiClient.onSessionExpired] when a token refresh itself
  /// fails mid-session (not just on app start) — forces the router back to
  /// the login screen rather than leaving the UI stuck mid-request.
  void forceUnauthenticated() {
    state = const AuthState.unauthenticated();
  }
}

import '../../../core/api/api_client.dart';
import '../domain/user.dart';

/// Mirrors `apps/web/src/lib/auth-client.ts` endpoint-for-endpoint — the
/// mobile app reuses the exact same auth surface as the web companion (see
/// docs/security.md), nothing added or changed backend-side for Phase 9.5.
class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<User> login(String email, String password) async {
    final data = await _client.post(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
      skipAuth: true,
    ) as Map<String, dynamic>;
    _client.setAccessToken(data['accessToken'] as String);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<User> register(String email, String password, String displayName) async {
    final data = await _client.post(
      '/api/v1/auth/register',
      data: {'email': email, 'password': password, 'displayName': displayName},
      skipAuth: true,
    ) as Map<String, dynamic>;
    _client.setAccessToken(data['accessToken'] as String);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _client.post('/api/v1/auth/logout', skipAuth: true);
    } catch (_) {
      // Best-effort server-side revocation; local session clears regardless.
    }
    await _client.clearSession();
  }

  Future<void> logoutAllDevices() async {
    await _client.post('/api/v1/auth/logout-all');
    await _client.clearSession();
  }

  /// Trades the persisted refresh cookie (if any) for a fresh access token
  /// + current user, once on app start — same role as `bootstrapSession`
  /// on the web side.
  Future<User?> bootstrapSession() async {
    try {
      final refreshData =
          await _client.post('/api/v1/auth/refresh', skipAuth: true) as Map<String, dynamic>;
      _client.setAccessToken(refreshData['accessToken'] as String);
      final userData = await _client.get('/api/v1/users/me') as Map<String, dynamic>;
      return User.fromJson(userData);
    } catch (_) {
      return null;
    }
  }

  Future<void> requestPasswordReset(String email) => _client.post(
        '/api/v1/auth/password-reset/request',
        data: {'email': email},
        skipAuth: true,
      );

  Future<void> confirmPasswordReset(String token, String newPassword) => _client.post(
        '/api/v1/auth/password-reset/confirm',
        data: {'token': token, 'newPassword': newPassword},
        skipAuth: true,
      );

  Future<void> resendVerificationEmail() => _client.post('/api/v1/auth/verify-email/resend');

  Future<void> changePassword(String currentPassword, String newPassword) => _client.post(
        '/api/v1/users/me/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

  /// Permanent. The backend rejects this with `OWNS_ACTIVE_GROUPS` if the account still owns an
  /// active group — deleting it would otherwise cascade-delete that group for every other member.
  Future<void> deleteAccount(String password) async {
    await _client.delete('/api/v1/users/me', data: {'password': password});
    await _client.clearSession();
  }

  Future<List<Map<String, dynamic>>> listSessions() async {
    final data = await _client.get('/api/v1/auth/sessions') as List;
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> revokeSession(String sessionId) =>
      _client.delete('/api/v1/auth/sessions/$sessionId');
}

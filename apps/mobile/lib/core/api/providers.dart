import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/biometric_lock_service.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/application/auth_notifier.dart';
import '../../features/auth/application/auth_state.dart';
import '../../features/auth/data/auth_repository.dart';
import 'api_client.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final biometricLockServiceProvider =
    Provider((ref) => BiometricLockService(ref.watch(secureStorageProvider)));

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(secureStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final notifier = AuthNotifier(ref.watch(authRepositoryProvider));
  // Wired here (rather than inside apiClientProvider) to avoid a provider
  // dependency cycle: the client needs to signal the notifier, but the
  // notifier is built from a repository that depends on the client.
  ref.watch(apiClientProvider).onSessionExpired = notifier.forceUnauthenticated;
  return notifier;
});

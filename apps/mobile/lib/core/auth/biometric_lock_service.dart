import 'package:local_auth/local_auth.dart';

import '../storage/secure_storage.dart';

/// Optional device-level gate (Face ID / Touch ID / Android biometrics) on
/// an ALREADY-authenticated session — never a replacement for server-side
/// auth (docs/security.md). The backend JWT/refresh-cookie session is what
/// actually authorizes API calls; this only decides whether to show or hide
/// the app's content behind a local biometric prompt on resume, and is
/// user-disableable.
class BiometricLockService {
  BiometricLockService(this._storage) : _auth = LocalAuthentication();

  final LocalAuthentication _auth;
  final SecureStorage _storage;
  static const _enabledKey = 'biometric_lock_enabled';

  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isEnabled() async =>
      (await _storage.read(_enabledKey)) == 'true';

  Future<void> setEnabled(bool enabled) =>
      _storage.write(_enabledKey, enabled.toString());

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock Duitlah',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}

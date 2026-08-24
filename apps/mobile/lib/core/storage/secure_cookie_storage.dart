import 'package:cookie_jar/cookie_jar.dart';

import 'secure_storage.dart';

/// A [Storage] backend for `cookie_jar`'s `PersistCookieJar`, keeping the
/// backend's httpOnly-style refresh cookie encrypted at rest (Keychain /
/// EncryptedSharedPreferences) instead of the package's default plaintext
/// file storage. This is what lets the Flutter app reuse the exact same
/// JWT-access-token + refresh-cookie session model as the web app without
/// any backend changes — see docs/security.md.
class SecureCookieStorage extends Storage {
  SecureCookieStorage(this._secureStorage);

  final SecureStorage _secureStorage;
  static const _keyPrefix = 'cookie_jar.';
  final List<String> _knownKeys = [];

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {}

  @override
  Future<String?> read(String key) => _secureStorage.read('$_keyPrefix$key');

  @override
  Future<void> write(String key, String value) async {
    _knownKeys.add(key);
    await _secureStorage.write('$_keyPrefix$key', value);
  }

  @override
  Future<void> delete(String key) async {
    _knownKeys.remove(key);
    await _secureStorage.delete('$_keyPrefix$key');
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (final key in {...keys, ..._knownKeys}) {
      await _secureStorage.delete('$_keyPrefix$key');
    }
    _knownKeys.clear();
  }
}

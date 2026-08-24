import 'dart:io' show Platform;

/// Backend base URL. Override at build/run time with
/// `--dart-define=API_BASE_URL=https://your-host:8080` for a real device or
/// a non-default docker-compose host. Defaults match the existing
/// `apps/web/.env.example` convention (`http://localhost:8080`), adjusted
/// per-platform since "localhost" means different things to an iOS
/// simulator (the host machine) vs. an Android emulator (its own loopback —
/// `10.0.2.2` is the documented alias for the host).
class Env {
  Env._();

  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_override.isNotEmpty) return _override;
    if (!Platform.isAndroid) return 'http://localhost:8080';
    return 'http://10.0.2.2:8080';
  }

  /// The web companion's origin, used to build the guest Bagilah fallback
  /// link and to recognize incoming universal/app links. Same override
  /// pattern as [apiBaseUrl].
  static const String webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}

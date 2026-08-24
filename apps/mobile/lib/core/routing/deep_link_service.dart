import 'dart:async';

import 'package:app_links/app_links.dart';

/// Listens for the exact same invite URL the web app already builds
/// (`buildBagilahInviteUrl` in `apps/web/src/lib/bagilah-invite.ts`:
/// `{origin}/bagilah/join?token={token}`) registered as a universal/app
/// link against this app. Deliberately not a second, parallel URL scheme —
/// one link serves both "opens the app if installed" and "falls back to
/// the Next.js web guest flow if not," per the Phase 9.5 migration doc.
///
/// A real production deployment needs the Apple App Site Association file
/// and Android `assetlinks.json` hosted at the web origin (signed with the
/// real Team ID / package fingerprint) for the OS to treat this as a true
/// universal link instead of opening the browser; that verification step
/// isn't buildable in this dev environment, but the client-side handling
/// here is what a verified link would invoke once installed.
class DeepLinkService {
  DeepLinkService(this._onBagilahToken);

  final void Function(String token) _onBagilahToken;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  Future<void> start() async {
    final initial = await _appLinks.getInitialLink();
    if (initial != null) _handle(initial);

    _subscription = _appLinks.uriLinkStream.listen(_handle);
  }

  void _handle(Uri uri) {
    if (uri.path == '/bagilah/join') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        _onBagilahToken(token);
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

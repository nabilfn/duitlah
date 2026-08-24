import 'dart:convert';

import '../../../core/storage/secure_storage.dart';

/// A guest's join result (`billId`/`participantId`/`guestToken`/`displayName`),
/// persisted so re-opening the app (or a deep link) can resume an in-progress
/// guest session without rejoining. Mirrors `apps/web/src/lib/guest-session.ts`,
/// but backed by secure storage rather than `sessionStorage` since a mobile
/// app has no natural "tab close" boundary to expire it — the token's own
/// 24h backend-side expiry (docs/security.md) is what actually bounds it.
class GuestSession {
  const GuestSession({
    required this.billId,
    required this.participantId,
    required this.guestToken,
    required this.displayName,
  });

  final String billId;
  final String participantId;
  final String guestToken;
  final String displayName;

  Map<String, dynamic> toJson() => {
        'billId': billId,
        'participantId': participantId,
        'guestToken': guestToken,
        'displayName': displayName,
      };

  factory GuestSession.fromJson(Map<String, dynamic> json) => GuestSession(
        billId: json['billId'] as String,
        participantId: json['participantId'] as String,
        guestToken: json['guestToken'] as String,
        displayName: json['displayName'] as String,
      );
}

class GuestSessionStore {
  GuestSessionStore(this._storage);

  final SecureStorage _storage;
  static const _key = 'bagilah.guest_session';

  Future<void> save(GuestSession session) =>
      _storage.write(_key, jsonEncode(session.toJson()));

  Future<GuestSession?> load() async {
    final raw = await _storage.read(_key);
    if (raw == null) return null;
    try {
      return GuestSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() => _storage.delete(_key);
}

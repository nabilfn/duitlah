import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/bagilah/data/guest_session_store.dart';

void main() {
  test('GuestSession round-trips through JSON without losing fields', () {
    const session = GuestSession(
      billId: 'bill-1',
      participantId: 'participant-1',
      guestToken: 'guest-token-abc',
      displayName: 'Ameer',
    );

    final decoded = GuestSession.fromJson(session.toJson());

    expect(decoded.billId, session.billId);
    expect(decoded.participantId, session.participantId);
    expect(decoded.guestToken, session.guestToken);
    expect(decoded.displayName, session.displayName);
  });
}

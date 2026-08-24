import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/notifications/domain/app_notification.dart';

void main() {
  test('AppNotification.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'type': 'BILL_DUE_SOON',
      'title': 'Astro is due soon',
      'body': 'Astro (RM 99.90) is due on 2026-09-15.',
      'read': false,
      'createdAt': '2026-08-22T10:00:00Z',
    };

    final notification = AppNotification.fromJson(json);

    expect(notification.type, 'BILL_DUE_SOON');
    expect(notification.read, isFalse);
  });
}

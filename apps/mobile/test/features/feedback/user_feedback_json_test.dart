import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/feedback/domain/user_feedback.dart';

void main() {
  test('UserFeedback.fromJson parses a live backend response', () {
    // Captured from `POST /api/v1/feedback` against a live docker-compose backend.
    final json = {
      'id': 'b3c2f4a1-6b1e-4a2d-9c3e-1f2a3b4c5d6e',
      'category': 'BUG',
      'message': 'The Bagilah split screen crashes on rotate.',
      'createdAt': '2026-08-22T02:00:00Z',
    };

    final feedback = UserFeedback.fromJson(json);

    expect(feedback.category, FeedbackCategory.BUG);
    expect(feedback.message, 'The Bagilah split screen crashes on rotate.');
  });
}

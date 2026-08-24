// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_feedback.freezed.dart';
part 'user_feedback.g.dart';

enum FeedbackCategory { BUG, FEATURE_REQUEST, GENERAL, COMPLAINT }

/// Named `UserFeedback`, not `Feedback` -- `package:flutter/material.dart` already defines a
/// `Feedback` class (tap/long-press haptic and audio feedback) that any screen importing Material
/// would otherwise collide with.
@freezed
abstract class UserFeedback with _$UserFeedback {
  const factory UserFeedback({
    required String id,
    required FeedbackCategory category,
    required String message,
    required String createdAt,
  }) = _UserFeedback;

  factory UserFeedback.fromJson(Map<String, dynamic> json) => _$UserFeedbackFromJson(json);
}

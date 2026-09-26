import 'package:flutter/material.dart';

/// One finite motion rhythm. Entry storytelling keeps its dedicated timeline.
abstract final class AppMotion {
  static const micro = Duration(milliseconds: 140);
  static const control = Duration(milliseconds: 220);
  static const sheet = Duration(milliseconds: 340);
  static const page = Duration(milliseconds: 360);
  static const success = Duration(milliseconds: 380);
  static const curve = Cubic(.22, 1, .36, 1);
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}

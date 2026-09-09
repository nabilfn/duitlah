import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Status/brand colors the standard Material [ColorScheme] has no slot for
/// (success, warning, info, and Bagilah's own accent) — accessed via
/// `Theme.of(context).extension<AppSemanticColors>()!`.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.bagilah,
    required this.bagilahForeground,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color bagilah;
  final Color bagilahForeground;

  /// Bagilah shares the forest/sage palette; its signature is the organic
  /// composition rather than a competing saturated brand color.
  static const light = AppSemanticColors(
    success: AppColors.positive,
    warning: Color(0xFF945000),
    info: AppColors.tealDark,
    bagilah: AppColors.sage,
    bagilahForeground: AppColors.lightInk,
  );

  static const dark = AppSemanticColors(
    success: AppColors.positiveBright,
    warning: AppColors.orangeBright,
    info: AppColors.tealBright,
    bagilah: AppColors.tealBright,
    bagilahForeground: AppColors.lightInk,
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? bagilah,
    Color? bagilahForeground,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      bagilah: bagilah ?? this.bagilah,
      bagilahForeground: bagilahForeground ?? this.bagilahForeground,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      bagilah: Color.lerp(bagilah, other.bagilah, t)!,
      bagilahForeground: Color.lerp(
        bagilahForeground,
        other.bagilahForeground,
        t,
      )!,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}

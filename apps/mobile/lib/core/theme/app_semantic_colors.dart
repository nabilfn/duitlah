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

  /// Bagilah gets Duitlah's orange accent, not teal — the flagship feature
  /// should read as its own moment even resting among ordinary teal actions,
  /// the same reasoning `apps/web`'s own design system uses for its
  /// (differently-hued) Bagilah color. Orange at full strength needs a dark
  /// foreground, not white — a light, saturated color fails contrast with
  /// white text.
  static const light = AppSemanticColors(
    success: AppColors.positive,
    warning: AppColors.orange,
    info: AppColors.tealDark,
    bagilah: AppColors.orange,
    bagilahForeground: AppColors.lightInk,
  );

  static const dark = AppSemanticColors(
    success: AppColors.positiveBright,
    warning: AppColors.orangeBright,
    info: AppColors.tealBright,
    bagilah: AppColors.orangeBright,
    bagilahForeground: AppColors.darkInk,
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
      bagilahForeground: Color.lerp(bagilahForeground, other.bagilahForeground, t)!,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}

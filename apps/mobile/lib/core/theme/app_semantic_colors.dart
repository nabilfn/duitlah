import 'package:flutter/material.dart';

import 'duitlah_colors.dart';

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

  static final light = _fromPalette(DuitlahColors.light);
  static final dark = _fromPalette(DuitlahColors.dark);

  static AppSemanticColors _fromPalette(DuitlahColors palette) => AppSemanticColors(
    success: palette.positive,
    warning: palette.warning,
    info: palette.information,
    bagilah: palette.primarySoft,
    bagilahForeground: palette.textPrimary,
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

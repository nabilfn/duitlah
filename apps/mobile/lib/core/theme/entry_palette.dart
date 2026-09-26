import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'duitlah_colors.dart';

/// The deep-navy environment used only by app entry, loading and login.
///
/// The rest of the product is primarily light; this palette exists so the
/// branded entrance stays one continuous navy system from the first frame
/// through to the Home hero, without leaking into the app's own themes.
abstract final class EntryPalette {
  static const background = Color(0xFF081321);
  static const backgroundDeep = Color(0xFF06101B);
  static const blue = Color(0xFF78B5FF);
  static const blueSoft = Color(0xFFA9C8EE);
  static const text = Color(0xFFF7F9FC);
  static const textMuted = Color(0xFF90A1B6);

  /// Selective material for form controls — never a single giant glass card.
  static const fieldFill = Color(0x0FFFFFFF);
  static const fieldFillFocused = Color(0x1AFFFFFF);
  static const fieldBorder = Color(0x14FFFFFF);
  static const fieldBorderFocused = Color(0x6678B5FF);
  static const fieldBlur = 14.0;

  /// A soft premium ease: settles quickly, then glides. No overshoot anywhere
  /// in the entry flow — bounce reads as playful, not as a system waking up.
  static const curve = Cubic(0.22, 1, 0.36, 1);

  /// Dark theme pinned to the entry navy, regardless of the user's appearance
  /// setting. Login is deliberately dark in both light and dark app themes.
  static ThemeData theme() => _theme ??= _build();
  static ThemeData? _theme;

  static ThemeData _build() {
    final base = AppTheme.dark();
    final colors = (base.extension<DuitlahColors>() ?? DuitlahColors.dark)
        .copyWith(
          background: background,
          surface: backgroundDeep,
          surfaceSecondary: backgroundDeep,
          surfaceElevated: const Color(0xFF0D1A2B),
          primary: blue,
          primaryDark: blueSoft,
          textPrimary: text,
          textSecondary: textMuted,
          textTertiary: textMuted,
          border: const Color(0xFF1C2C40),
          borderSubtle: const Color(0xFF162536),
        );
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      extensions: [
        ...base.extensions.values.where((e) => e is! DuitlahColors),
        colors,
      ],
    );
  }
}

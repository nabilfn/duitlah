import 'package:flutter/material.dart';

/// Exact colour roles from DUITLAH_COLOUR_THEME_UPDATE.md.
/// Geometry, typography and motion are deliberately outside this extension.
class DuitlahColors extends ThemeExtension<DuitlahColors> {
  const DuitlahColors({
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.surfaceElevated,
    required this.primary,
    required this.primaryDark,
    required this.primarySoft,
    required this.primarySubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnPrimary,
    required this.border,
    required this.borderSubtle,
    required this.positive,
    required this.positiveSoft,
    required this.negative,
    required this.negativeSoft,
    required this.warning,
    required this.warningSoft,
    required this.information,
    required this.informationSoft,
    required this.balanceBackground,
    required this.balanceText,
    required this.balanceSecondary,
    required this.balanceMuted,
    required this.balanceHighlight,
  });
  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color surfaceElevated;
  final Color primary;
  final Color primaryDark;
  final Color primarySoft;
  final Color primarySubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnPrimary;
  final Color border;
  final Color borderSubtle;
  final Color positive;
  final Color positiveSoft;
  final Color negative;
  final Color negativeSoft;
  final Color warning;
  final Color warningSoft;
  final Color information;
  final Color informationSoft;
  final Color balanceBackground;
  final Color balanceText;
  final Color balanceSecondary;
  final Color balanceMuted;
  final Color balanceHighlight;
  /// Stronger brand emphasis (called Primary Strong in the dark palette).
  Color get primaryStrong => primaryDark;
  static const light = DuitlahColors(
    background: Color(0xFFF7F5F1),
    surface: Color(0xFFFEFDFC),
    surfaceSecondary: Color(0xFFECE8E2),
    surfaceElevated: Color(0xFFFFFFFF),
    primary: Color(0xFF4A2438),
    primaryDark: Color(0xFF321724),
    primarySoft: Color(0xFFE6CFD8),
    primarySubtle: Color(0xFFF3E8EC),
    textPrimary: Color(0xFF1E1B1D),
    textSecondary: Color(0xFF6E676A),
    textTertiary: Color(0xFF90888B),
    textOnPrimary: Color(0xFFFFF9F5),
    border: Color(0xFFDED8D4),
    borderSubtle: Color(0xFFE9E4E0),
    positive: Color(0xFF34705A),
    positiveSoft: Color(0xFFE5F0EB),
    negative: Color(0xFFB85C4B),
    negativeSoft: Color(0xFFF5E8E4),
    warning: Color(0xFFB68435),
    warningSoft: Color(0xFFF6EEDA),
    information: Color(0xFF526C89),
    informationSoft: Color(0xFFE8EDF2),
    balanceBackground: Color(0xFF4A2438),
    balanceText: Color(0xFFFFF9F5),
    balanceSecondary: Color(0xFFD8BEC9),
    balanceMuted: Color(0xFFC7ABB7),
    balanceHighlight: Color(0xFFE8D5DD),
  );
  static const dark = DuitlahColors(
    background: Color(0xFF181416),
    surface: Color(0xFF211C1F),
    surfaceSecondary: Color(0xFF2B2427),
    surfaceElevated: Color(0xFF30282C),
    primary: Color(0xFFB97A94),
    primaryDark: Color(0xFFD09AAF),
    primarySoft: Color(0xFF573346),
    primarySubtle: Color(0xFF35242C),
    textPrimary: Color(0xFFF7F1F3),
    textSecondary: Color(0xFFAAA0A4),
    textTertiary: Color(0xFF81777B),
    textOnPrimary: Color(0xFF1D1418),
    border: Color(0xFF3B3236),
    borderSubtle: Color(0xFF30292C),
    positive: Color(0xFF72A68F),
    positiveSoft: Color(0xFF203A30),
    negative: Color(0xFFD98272),
    negativeSoft: Color(0xFF452925),
    warning: Color(0xFFD4A75F),
    warningSoft: Color(0xFF453720),
    information: Color(0xFF83A0BD),
    informationSoft: Color(0xFF263542),
    balanceBackground: Color(0xFF6A3B50),
    balanceText: Color(0xFFFFF8FA),
    balanceSecondary: Color(0xFFE2C9D3),
    balanceMuted: Color(0xFFCBAFBB),
    balanceHighlight: Color(0xFFE2C9D3),
  );
  static const participants = <Color>[
    Color(0xFF6D3D55),
    Color(0xFFAD6B68),
    Color(0xFFC7924B),
    Color(0xFF657A63),
    Color(0xFF60768A),
    Color(0xFF8B708F),
    Color(0xFFB88478),
  ];

  Color softFor(Color tone) {
    if (tone == positive) return positiveSoft;
    if (tone == negative) return negativeSoft;
    if (tone == warning) return warningSoft;
    if (tone == information) return informationSoft;
    if (tone == primary) return primarySubtle;
    return tone.withValues(alpha: .14);
  }

  /// Exact participant fills include mid-tones that need black or white
  /// lettering to reach 4.5:1 without changing their specified colours.
  Color onParticipant(Color background) {
    final luminance = background.computeLuminance();
    final white = DuitlahColors.light.surfaceElevated;
    const black = Color(0xFF000000);
    final lightContrast = (white.computeLuminance() + .05) / (luminance + .05);
    final darkContrast = (luminance + .05) / .05;
    return lightContrast >= darkContrast ? white : black;
  }

  @override
  DuitlahColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceSecondary,
    Color? surfaceElevated,
    Color? primary,
    Color? primaryDark,
    Color? primarySoft,
    Color? primarySubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnPrimary,
    Color? border,
    Color? borderSubtle,
    Color? positive,
    Color? positiveSoft,
    Color? negative,
    Color? negativeSoft,
    Color? warning,
    Color? warningSoft,
    Color? information,
    Color? informationSoft,
    Color? balanceBackground,
    Color? balanceText,
    Color? balanceSecondary,
    Color? balanceMuted,
    Color? balanceHighlight,
  }) => DuitlahColors(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
    surfaceElevated: surfaceElevated ?? this.surfaceElevated,
    primary: primary ?? this.primary,
    primaryDark: primaryDark ?? this.primaryDark,
    primarySoft: primarySoft ?? this.primarySoft,
    primarySubtle: primarySubtle ?? this.primarySubtle,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textTertiary: textTertiary ?? this.textTertiary,
    textOnPrimary: textOnPrimary ?? this.textOnPrimary,
    border: border ?? this.border,
    borderSubtle: borderSubtle ?? this.borderSubtle,
    positive: positive ?? this.positive,
    positiveSoft: positiveSoft ?? this.positiveSoft,
    negative: negative ?? this.negative,
    negativeSoft: negativeSoft ?? this.negativeSoft,
    warning: warning ?? this.warning,
    warningSoft: warningSoft ?? this.warningSoft,
    information: information ?? this.information,
    informationSoft: informationSoft ?? this.informationSoft,
    balanceBackground: balanceBackground ?? this.balanceBackground,
    balanceText: balanceText ?? this.balanceText,
    balanceSecondary: balanceSecondary ?? this.balanceSecondary,
    balanceMuted: balanceMuted ?? this.balanceMuted,
    balanceHighlight: balanceHighlight ?? this.balanceHighlight,
  );
  @override
  DuitlahColors lerp(covariant DuitlahColors? other, double t) {
    if (other == null) return this;
    return DuitlahColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSecondary: Color.lerp(surfaceSecondary, other.surfaceSecondary, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      positiveSoft: Color.lerp(positiveSoft, other.positiveSoft, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      negativeSoft: Color.lerp(negativeSoft, other.negativeSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      information: Color.lerp(information, other.information, t)!,
      informationSoft: Color.lerp(informationSoft, other.informationSoft, t)!,
      balanceBackground: Color.lerp(balanceBackground, other.balanceBackground, t)!,
      balanceText: Color.lerp(balanceText, other.balanceText, t)!,
      balanceSecondary: Color.lerp(balanceSecondary, other.balanceSecondary, t)!,
      balanceMuted: Color.lerp(balanceMuted, other.balanceMuted, t)!,
      balanceHighlight: Color.lerp(balanceHighlight, other.balanceHighlight, t)!,
    );
  }
}

extension DuitlahColorsContext on BuildContext {
  DuitlahColors get duitlahColors => Theme.of(this).extension<DuitlahColors>() ??
      (Theme.of(this).brightness == Brightness.dark ? DuitlahColors.dark : DuitlahColors.light);
}

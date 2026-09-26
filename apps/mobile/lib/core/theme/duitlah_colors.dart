import 'package:flutter/material.dart';

/// Soft Editorial Glass colour roles, shared across personal and business flows.
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
    background: Color(0xFFF5F5F2),
    surface: Color(0xFFFCFCFA),
    surfaceSecondary: Color(0xFFEFEFEB),
    surfaceElevated: Color(0xFFFFFFFF),
    primary: Color(0xFF0E1B30),
    primaryDark: Color(0xFF09131F),
    primarySoft: Color(0xFFDCE6EF),
    primarySubtle: Color(0xFFEDF1F5),
    textPrimary: Color(0xFF111317),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF767E8A),
    textOnPrimary: Color(0xFFF5F7FA),
    border: Color(0xFFE3E4E3),
    borderSubtle: Color(0xFFEBECE9),
    positive: Color(0xFF34705A),
    positiveSoft: Color(0xFFE5F0EB),
    negative: Color(0xFFB85C4B),
    negativeSoft: Color(0xFFF5E8E4),
    warning: Color(0xFFB68435),
    warningSoft: Color(0xFFF6EEDA),
    information: Color(0xFF526C89),
    informationSoft: Color(0xFFE8EDF2),
    balanceBackground: Color(0xFF0E1B30),
    balanceText: Color(0xFFF5F7FA),
    balanceSecondary: Color(0xFFAFCFF4),
    balanceMuted: Color(0xFFABB4C0),
    balanceHighlight: Color(0xFFAFCFF4),
  );
  static const dark = DuitlahColors(
    background: Color(0xFF070A10),
    surface: Color(0xFF101721),
    surfaceSecondary: Color(0xFF0C1118),
    surfaceElevated: Color(0xFF141D29),
    primary: Color(0xFFAFCFF4),
    primaryDark: Color(0xFF73B8FF),
    primarySoft: Color(0xFF1D3553),
    primarySubtle: Color(0xFF182C45),
    textPrimary: Color(0xFFF5F7FA),
    textSecondary: Color(0xFFABB4C0),
    textTertiary: Color(0xFF8893A2),
    textOnPrimary: Color(0xFF09131F),
    border: Color(0xFF28313D),
    borderSubtle: Color(0xFF1E2733),
    positive: Color(0xFF72A68F),
    positiveSoft: Color(0xFF203A30),
    negative: Color(0xFFD98272),
    negativeSoft: Color(0xFF452925),
    warning: Color(0xFFD4A75F),
    warningSoft: Color(0xFF453720),
    information: Color(0xFF83A0BD),
    informationSoft: Color(0xFF263542),
    balanceBackground: Color(0xFF16263B),
    balanceText: Color(0xFFF5F7FA),
    balanceSecondary: Color(0xFFAFCFF4),
    balanceMuted: Color(0xFFABB4C0),
    balanceHighlight: Color(0xFFAFCFF4),
  );
  static const participants = <Color>[
    Color(0xFF223B5A),
    Color(0xFF526C89),
    Color(0xFF748A9D),
    Color(0xFF627D7A),
    Color(0xFF60768A),
    Color(0xFF8192A6),
    Color(0xFF9CABA9),
  ];

  /// Chart marks need separation from the page in each independently tuned theme.
  List<Color> get chartColors => surface.computeLuminance() < .1
      ? const [
          Color(0xFFAFCDF0),
          Color(0xFF73B8FF),
          Color(0xFF8EA4BC),
          Color(0xFF6989AB),
          Color(0xFF7896B0),
          Color(0xFF769799),
        ]
      : const [
          Color(0xFF24415F),
          Color(0xFF526C89),
          Color(0xFF748A9D),
          Color(0xFF627D7A),
          Color(0xFF60768A),
          Color(0xFF8192A6),
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
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
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
      balanceBackground: Color.lerp(
        balanceBackground,
        other.balanceBackground,
        t,
      )!,
      balanceText: Color.lerp(balanceText, other.balanceText, t)!,
      balanceSecondary: Color.lerp(
        balanceSecondary,
        other.balanceSecondary,
        t,
      )!,
      balanceMuted: Color.lerp(balanceMuted, other.balanceMuted, t)!,
      balanceHighlight: Color.lerp(
        balanceHighlight,
        other.balanceHighlight,
        t,
      )!,
    );
  }
}

extension DuitlahColorsContext on BuildContext {
  DuitlahColors get duitlahColors =>
      Theme.of(this).extension<DuitlahColors>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? DuitlahColors.dark
          : DuitlahColors.light);
}

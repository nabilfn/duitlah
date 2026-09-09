import 'package:flutter/material.dart';

import 'duitlah_colors.dart';
import 'app_semantic_colors.dart';

/// Spacing scale used throughout the design system instead of ad-hoc magic
/// numbers (mobile redesign spec: 4/8/12/16/20/24/32).
class AppSpacing {
  AppSpacing._();
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Standard horizontal page margin (mobile redesign spec: 20px) — kept
  /// distinct from the xs/sm/md/lg/xl/xxl rhythm since it's a fixed layout
  /// constant, not a step in that scale.
  static const pageMargin = 20.0;
}

/// Radii scale from the mobile redesign spec — small controls (10–12px),
/// inputs (12–14px), standard cards (16–18px), prominent financial cards
/// (20–24px). Field names kept stable from the pre-redesign theme (only
/// `sm`/`md`/`lg`/`pill` are referenced outside this file) even though the
/// underlying values changed.
class AppRadius {
  AppRadius._();
  static const sm = 12.0;
  static const input = 14.0;
  static const md = 20.0;
  static const lg = 22.0;
  static const pill = 999.0;
}

/// The existing design with the supplied berry light/dark colour palettes.
class AppTheme {
  AppTheme._();

  static const _fontFamily = 'Plus Jakarta Sans';

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final palette = isDark ? DuitlahColors.dark : DuitlahColors.light;
    final background = palette.background;
    final card = palette.surface;
    final ink = palette.textPrimary;
    final muted = palette.textSecondary;
    final border = palette.border;
    final tealSoft = palette.primarySoft;
    final teal = palette.primary;
    final negative = palette.negative;

    final colorScheme = ColorScheme(
      brightness: brightness,
      surface: background,
      onSurface: ink,
      primary: teal,
      onPrimary: palette.textOnPrimary,
      secondary: tealSoft,
      onSecondary: palette.primary,
      error: negative,
      onError: palette.onParticipant(negative),
      outline: border,
      onSurfaceVariant: muted,
      surfaceContainerLow: card,
      surfaceContainer: palette.surfaceSecondary,
      surfaceContainerHighest: card,
      surfaceContainerLowest: background,
      surfaceContainerHigh: palette.surfaceElevated,
      primaryContainer: palette.primarySubtle,
      onPrimaryContainer: palette.primary,
      secondaryContainer: palette.primarySoft,
      onSecondaryContainer: ink,
      tertiary: palette.information,
      onTertiary: palette.onParticipant(palette.information),
      tertiaryContainer: palette.informationSoft,
      onTertiaryContainer: palette.information,
      errorContainer: palette.negativeSoft,
      onErrorContainer: palette.negative,
      outlineVariant: palette.borderSubtle,
      inverseSurface: palette.primaryDark,
      onInverseSurface: palette.textOnPrimary,
      inversePrimary: palette.primarySoft,
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: _fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      extensions: [palette, isDark ? AppSemanticColors.dark : AppSemanticColors.light],
      disabledColor: palette.textTertiary,
      hintColor: palette.textTertiary,
      focusColor: palette.primarySoft.withValues(alpha: .35),
      hoverColor: palette.primarySubtle,
      textSelectionTheme: TextSelectionThemeData(cursorColor: palette.primary, selectionColor: palette.primarySoft, selectionHandleColor: palette.primary),
      popupMenuTheme: PopupMenuThemeData(color: palette.surfaceElevated, surfaceTintColor: Colors.transparent),
      menuTheme: MenuThemeData(style: MenuStyle(backgroundColor: WidgetStatePropertyAll(palette.surfaceElevated), surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent))),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.2,
        ),
      ),
      textTheme: _textTheme(ink, muted),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: const WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? teal : palette.surfaceSecondary),
          foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? colorScheme.onPrimary : muted),
          minimumSize: const WidgetStatePropertyAll(Size(48, 44)),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tealSoft,
        selectedColor: tealSoft,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide.none,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: teal,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        iconColor: teal,
        minVerticalPadding: 8,
      ),
      dividerTheme: DividerThemeData(color: palette.borderSubtle, thickness: 1, space: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: teal,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: teal.withValues(alpha: 0.35),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontFamily: _fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              elevation: 0,
            ).copyWith(
              // Pressed state uses the spec's dedicated "dark teal", not a
              // generic opacity overlay on the primary color.
              overlayColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.pressed)
                    ? palette.primaryDark.withValues(alpha: 0.12)
                    : null,
              ),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: negative, width: 1.5),
        ),
        hintStyle: TextStyle(fontFamily: _fontFamily, color: muted),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surfaceElevated,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        showDragHandle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: tealSoft,
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        // Redesign spec: "Active navigation: teal icon, teal label" /
        // "Inactive: muted navy/grey" — Material3's own default only tints
        // the icon on selection, leaving the label a flat navy in both
        // states.
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? (palette.primary)
                : muted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? (palette.primary)
                : muted,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surfaceElevated,
        contentTextStyle: TextStyle(
          fontFamily: _fontFamily,
          color: palette.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceElevated,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
      ),
    );
  }

  /// Financial-number hierarchy per the redesign spec: display figures get
  /// ExtraBold, page titles Bold, section headings SemiBold, body
  /// Regular/Medium, captions Medium — never left at the Material default
  /// weight, since "financial values should always be visually prominent".
  static TextTheme _textTheme(Color ink, Color muted) {
    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: muted,
      ),
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
    );
  }
}

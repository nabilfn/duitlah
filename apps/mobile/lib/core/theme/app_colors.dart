import 'package:flutter/widgets.dart';

/// Duitlah's design system (mobile redesign — see docs/DESIGN.md). Warm
/// off-white background in light mode / deep navy in dark mode, Duitlah
/// teal as the one primary action color across both, and a small orange
/// accent reserved for highlights rather than primary actions. `apps/web`
/// keeps its own separate (berry-rose) brand palette — this redesign is
/// mobile-only, not a whole-product rebrand.
class AppColors {
  AppColors._();

  // Light
  static const lightBackground = Color(0xFFF8F9F7);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightInk = Color(0xFF0D1B2A);
  static const lightMutedForeground = Color(0xFF6B7479);
  static const lightBorder = Color(0xFFE6EAE8);
  static const lightTealSoft = Color(0xFFE5F8F7);

  // Dark — a navy family derived from the same brand ink, not a generic
  // near-black, so dark mode still reads as distinctly Duitlah.
  static const darkBackground = Color(0xFF0A1420);
  static const darkCard = Color(0xFF131F2E);
  static const darkInk = Color(0xFFF2F5F7);
  static const darkMutedForeground = Color(0xFF8B94A0);
  static const darkBorder = Color(0xFF25313F);
  static const darkTealSoft = Color(0xFF123638);

  // Duitlah teal (primary brand color) — the same hue in both modes,
  // brightened slightly for dark backgrounds so it keeps enough contrast
  // and "pop" rather than reading muddy against navy.
  static const teal = Color(0xFF00A8AD);
  static const tealDark = Color(0xFF007F84);
  static const tealBright = Color(0xFF1DC4C9);

  // Orange (supporting accent only — never a primary button or large panel)
  static const orange = Color(0xFFFF8A00);
  static const orangeBright = Color(0xFFFFA033);

  // Financial state
  static const positive = Color(0xFF07966D);
  static const positiveBright = Color(0xFF2FBF8F);
  static const negative = Color(0xFFE85C5C);
  static const negativeBright = Color(0xFFFF6B6B);
}

import 'dart:ui';

import 'package:flutter/material.dart';

enum GlassMaterial { standard, strong, soft, hero }

/// Four related materials, shared by navigation, controls, menus and sheets.
abstract final class GlassTokens {
  static const radius = 18.0;
  static const blur = 18.0;
  static const strongBlur = 22.0;
  static const heroBlur = 10.0;
  static const lightBase = Color(0xFFFAFBF9);
  static const darkBase = Color(0xFF111823);
  static const lightBorder = Color(0x85FFFFFF);
  static const darkBorder = Color(0x14FFFFFF);
  static const lightHighlight = Color(0xB8FFFFFF);
  static const darkHighlight = Color(0x1AFFFFFF);

  static Color background(
    bool dark,
    GlassMaterial material, {
    bool pressed = false,
    bool solid = false,
  }) {
    final (base, alpha) = switch (material) {
      GlassMaterial.standard => (dark ? darkBase : lightBase, .62),
      GlassMaterial.strong => (
        dark ? const Color(0xFF121B28) : const Color(0xFFF8F9F7),
        dark ? .76 : .74,
      ),
      GlassMaterial.soft => (
        dark ? const Color(0xFF1B2736) : Colors.white,
        dark ? .52 : .46,
      ),
      GlassMaterial.hero => (
        solid ? const Color(0xFF223B54) : Colors.white,
        .08,
      ),
    };
    return base.withValues(
      alpha: solid ? 1 : (alpha + (pressed ? .08 : 0)).clamp(0, 1),
    );
  }

  static Color border(bool dark, GlassMaterial material) =>
      material == GlassMaterial.hero
      ? const Color(0x1FFFFFFF)
      : dark
      ? darkBorder
      : lightBorder;
  static Color highlight(bool dark, GlassMaterial material) =>
      material == GlassMaterial.hero
      ? const Color(0x33FFFFFF)
      : dark
      ? darkHighlight
      : lightHighlight;
  static BoxShadow shadow(bool dark, bool pressed) => BoxShadow(
    color: dark ? const Color(0x38000000) : const Color(0x1409131F),
    offset: Offset(0, pressed ? 3 : 8),
    blurRadius: pressed ? 12 : 28,
  );
  // Fixed, cached filters; never synthesize a new blur kernel for every scroll tick.
  static final standardFilter = _filter(blur, 1.25);
  static final strongFilter = _filter(strongBlur, 1.35);
  static final heroFilter = ImageFilter.blur(
    sigmaX: heroBlur,
    sigmaY: heroBlur,
  );
  static ImageFilter filter(GlassMaterial material, bool active) =>
      material == GlassMaterial.hero
      ? heroFilter
      : active || material == GlassMaterial.strong
      ? strongFilter
      : standardFilter;
  static ImageFilter _filter(double sigma, double saturation) {
    final r = .2126 * (1 - saturation),
        g = .7152 * (1 - saturation),
        b = .0722 * (1 - saturation);
    return ImageFilter.compose(
      outer: ColorFilter.matrix([
        r + saturation,
        g,
        b,
        0,
        0,
        r,
        g + saturation,
        b,
        0,
        0,
        r,
        g,
        b + saturation,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      inner: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
    );
  }
}

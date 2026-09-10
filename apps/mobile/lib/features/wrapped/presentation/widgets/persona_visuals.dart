import 'package:flutter/material.dart';

import '../../../../core/theme/duitlah_colors.dart';

/// A colour treatment for one `visualTheme` key — an accent (the motif's line colour, also
/// used for the persona's big typography) plus a soft full-bleed background. Built entirely
/// from [DuitlahColors] tokens (never a hardcoded hex) so every persona still resolves
/// correctly in light, dark and system theme.
///
/// Ten themes, ten distinct (accent, background) token pairs — no two personas share the
/// exact same pair, so the reveal screen reads as a genuinely different "world" each month
/// even though every persona is built from the same restrained Duitlah palette.
class PersonaTreatment {
  const PersonaTreatment({
    required this.accent,
    required this.background,
    required this.onBackground,
  });
  final Color accent;
  final Color background;
  final Color onBackground;
}

/// Resolves the colour treatment for a `visualTheme` key. Falls back to the neutral
/// balance/brand treatment for an unrecognised key so a future backend addition never
/// crashes the story screen — it just renders with the app's default brand colours until
/// this map is updated.
PersonaTreatment personaTreatment(BuildContext context, String visualTheme) {
  final c = context.duitlahColors;
  switch (visualTheme) {
    case 'cafe_hunter':
      return PersonaTreatment(
        accent: c.warning,
        background: c.warningSoft,
        onBackground: c.textPrimary,
      );
    case 'checkout_champion':
      return PersonaTreatment(
        accent: c.negative,
        background: c.negativeSoft,
        onBackground: c.textPrimary,
      );
    case 'jalan_jalan_ceo':
      return PersonaTreatment(
        accent: c.information,
        background: c.informationSoft,
        onBackground: c.textPrimary,
      );
    case 'auto_renew_royalty':
      return PersonaTreatment(
        accent: c.primary,
        background: c.primarySubtle,
        onBackground: c.textPrimary,
      );
    case 'tabung_titan':
      return PersonaTreatment(
        accent: c.positive,
        background: c.positiveSoft,
        onBackground: c.textPrimary,
      );
    case 'budget_ninja':
      return PersonaTreatment(
        accent: c.primaryDark,
        background: c.primarySoft,
        onBackground: c.textPrimary,
      );
    case 'memory_collector':
      return PersonaTreatment(
        accent: c.primary,
        background: c.informationSoft,
        onBackground: c.textPrimary,
      );
    case 'life_admin_legend':
      return PersonaTreatment(
        accent: c.positive,
        background: c.primarySubtle,
        onBackground: c.textPrimary,
      );
    case 'makan_mission_specialist':
      return PersonaTreatment(
        accent: c.negative,
        background: c.warningSoft,
        onBackground: c.textPrimary,
      );
    case 'digital_loot_goblin':
      return PersonaTreatment(
        accent: c.information,
        background: c.primarySoft,
        onBackground: c.textPrimary,
      );
    default:
      return PersonaTreatment(
        accent: c.primary,
        background: c.primarySubtle,
        onBackground: c.textPrimary,
      );
  }
}

/// A larger, more expressive sibling to `DuitlahIcon` — same hand-drawn, stroke-based idiom
/// (rounded caps/joins, a single line weight, no fills beyond the stroke) but scaled up and
/// built specifically for the 10 Wrapped persona "object worlds". Deliberately not built as
/// `CustomPainter`-per-file; one switch-based painter mirrors `duitlah_icon.dart`'s own
/// `_GlyphPainter` structure exactly.
class PersonaMotif extends StatelessWidget {
  const PersonaMotif(
    this.visualTheme, {
    super.key,
    this.size = 120,
    this.color,
  });
  final String visualTheme;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final stroke = color ?? personaTreatment(context, visualTheme).accent;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _PersonaMotifPainter(visualTheme, stroke)),
    );
  }
}

class _PersonaMotifPainter extends CustomPainter {
  const _PersonaMotifPainter(this.theme, this.color);
  final String theme;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // A fixed 100-unit design grid, scaled to the requested box — proportionally the same
    // stroke-to-viewport ratio `duitlah_icon.dart` uses at its own 24-unit grid (1.7/24 ≈ 7%).
    canvas.scale(size.width / 100, size.height / 100);
    final pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    void line(double x, double y, double x2, double y2) =>
        canvas.drawLine(Offset(x, y), Offset(x2, y2), pen);
    void circle(double x, double y, double r) =>
        canvas.drawCircle(Offset(x, y), r, pen);
    void box(double x, double y, double w, double h, [double r = 8]) =>
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, w, h),
            Radius.circular(r),
          ),
          pen,
        );
    void path(List<Offset> points, {bool close = false}) {
      final p = Path()..moveTo(points.first.dx, points.first.dy);
      for (final o in points.skip(1)) {
        p.lineTo(o.dx, o.dy);
      }
      if (close) p.close();
      canvas.drawPath(p, pen);
    }

    switch (theme) {
      case 'cafe_hunter':
        // Cup + saucer + curling steam.
        path([
          const Offset(28, 40),
          const Offset(24, 82),
          const Offset(76, 82),
          const Offset(72, 40),
        ], close: true);
        line(18, 88, 82, 88);
        canvas.drawArc(
          const Rect.fromLTWH(70, 46, 20, 24),
          -1.2,
          2.2,
          false,
          pen,
        );
        for (final dx in [36.0, 50.0, 64.0]) {
          canvas.drawPath(
            Path()
              ..moveTo(dx, 32)
              ..cubicTo(dx - 8, 22, dx + 8, 14, dx, 6),
            pen,
          );
        }

      case 'checkout_champion':
        // Shopping bag with two handles + receipt lines inside.
        path([
          const Offset(24, 38),
          const Offset(76, 38),
          const Offset(70, 88),
          const Offset(30, 88),
        ], close: true);
        canvas.drawArc(
          const Rect.fromLTWH(32, 14, 18, 30),
          3.14,
          3.14,
          false,
          pen,
        );
        canvas.drawArc(
          const Rect.fromLTWH(50, 14, 18, 30),
          3.14,
          3.14,
          false,
          pen,
        );
        line(38, 58, 62, 58);
        line(38, 70, 56, 70);

      case 'jalan_jalan_ceo':
        // A winding route to a location pin.
        canvas.drawPath(
          Path()
            ..moveTo(10, 88)
            ..cubicTo(35, 88, 20, 55, 45, 52)
            ..cubicTo(65, 50, 55, 25, 72, 20),
          pen,
        );
        canvas.drawPath(
          Path()
            ..moveTo(72, 8)
            ..cubicTo(60, 8, 60, 24, 72, 34)
            ..cubicTo(84, 24, 84, 8, 72, 8)
            ..close(),
          pen,
        );
        circle(72, 17, 4.5);

      case 'auto_renew_royalty':
        // Three stacked subscription cards + a repeat/loop glyph.
        box(14, 46, 46, 30, 6);
        box(22, 34, 46, 30, 6);
        box(30, 22, 46, 30, 6);
        canvas.drawArc(
          const Rect.fromLTWH(58, 58, 26, 26),
          -0.6,
          4.6,
          false,
          pen,
        );
        path([
          const Offset(80, 56),
          const Offset(86, 62),
          const Offset(80, 68),
        ]);

      case 'tabung_titan':
        // Piggy bank: rounded body, ear/snout, coin slot, legs, coin above.
        canvas.drawPath(
          Path()
            ..moveTo(18, 55)
            ..cubicTo(14, 30, 40, 20, 58, 24)
            ..cubicTo(70, 20, 84, 26, 84, 42)
            ..cubicTo(84, 60, 70, 70, 55, 70)
            ..cubicTo(40, 70, 20, 68, 18, 55)
            ..close(),
          pen,
        );
        line(46, 34, 58, 34);
        circle(74, 42, 2.6);
        line(30, 70, 28, 82);
        line(60, 70, 62, 82);
        circle(70, 12, 8);
        line(70, 8, 70, 16);

      case 'budget_ninja':
        // Shield with a bullseye — protection + precision.
        canvas.drawPath(
          Path()
            ..moveTo(50, 8)
            ..lineTo(84, 22)
            ..lineTo(80, 60)
            ..cubicTo(74, 78, 60, 88, 50, 92)
            ..cubicTo(40, 88, 26, 78, 20, 60)
            ..lineTo(16, 22)
            ..close(),
          pen,
        );
        circle(50, 48, 18);
        circle(50, 48, 8);

      case 'memory_collector':
        // Ticket stub: notched rounded rect + perforation dots.
        canvas.drawPath(
          Path()
            ..moveTo(12, 30)
            ..lineTo(88, 30)
            ..lineTo(88, 70)
            ..lineTo(12, 70)
            ..close(),
          pen,
        );
        canvas.drawArc(const Rect.fromLTWH(44, 22, 12, 16), 0, 3.14, true, pen);
        canvas.drawArc(
          const Rect.fromLTWH(44, 62, 12, 16),
          3.14,
          3.14,
          true,
          pen,
        );
        for (final dy in [38.0, 48.0, 58.0]) {
          circle(50, dy, 1.4);
        }

      case 'life_admin_legend':
        // Clipboard with a checklist and a completed check.
        box(24, 14, 52, 74, 8);
        box(40, 8, 20, 12, 4);
        line(34, 34, 58, 34);
        line(34, 48, 58, 48);
        path([
          const Offset(34, 62),
          const Offset(40, 68),
          const Offset(58, 56),
        ]);

      case 'makan_mission_specialist':
        // A steaming bowl.
        canvas.drawArc(
          const Rect.fromLTWH(16, 46, 68, 40),
          0,
          3.14,
          false,
          pen,
        );
        line(16, 60, 84, 60);
        canvas.drawArc(
          const Rect.fromLTWH(-2, 46, 20, 12),
          -0.2,
          1.6,
          false,
          pen,
        );
        canvas.drawArc(
          const Rect.fromLTWH(82, 46, 20, 12),
          1.5,
          1.6,
          false,
          pen,
        );
        for (final dx in [40.0, 52.0, 64.0]) {
          canvas.drawPath(
            Path()
              ..moveTo(dx, 40)
              ..cubicTo(dx - 7, 30, dx + 7, 22, dx, 12),
            pen,
          );
        }

      case 'digital_loot_goblin':
        // Game controller silhouette: d-pad left, two action buttons right.
        canvas.drawPath(
          Path()
            ..moveTo(22, 40)
            ..lineTo(78, 40)
            ..cubicTo(92, 40, 92, 66, 82, 74)
            ..cubicTo(74, 80, 68, 72, 62, 66)
            ..lineTo(38, 66)
            ..cubicTo(32, 72, 26, 80, 18, 74)
            ..cubicTo(8, 66, 8, 40, 22, 40)
            ..close(),
          pen,
        );
        line(28, 52, 28, 62);
        line(23, 57, 33, 57);
        circle(68, 48, 3.2);
        circle(78, 56, 3.2);

      default:
        box(20, 20, 60, 60, 10);
    }
  }

  @override
  bool shouldRepaint(_PersonaMotifPainter oldDelegate) =>
      oldDelegate.theme != theme || oldDelegate.color != color;
}

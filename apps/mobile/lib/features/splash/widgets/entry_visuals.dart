import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/entry_palette.dart';

/// The deep-navy canvas behind every entry stage.
///
/// Depth comes from three cheap layers only — a vertical gradient, one soft
/// radial pool and a few low-opacity technical arcs. No particles, no looping
/// animation: [depth] and [sweep] are driven by the entry timeline and settle.
class EntryEnvironmentPainter extends CustomPainter {
  const EntryEnvironmentPainter({
    required this.depth,
    required this.sweep,
    required this.reducedMotion,
  });

  /// 0 → flat navy, 1 → fully settled depth. Drives the pool and the drift.
  final double depth;

  /// A single light sweep travelling down the canvas, once, during loading.
  final double sweep;
  final bool reducedMotion;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            EntryPalette.background,
            EntryPalette.background,
            EntryPalette.backgroundDeep,
          ],
          stops: [0, .48, 1],
        ).createShader(rect),
    );

    // The pool sits a little above centre, where the `d.` signal lands, and
    // drifts a couple of pixels as the system settles — felt, not noticed.
    final drift = reducedMotion ? 0.0 : 4 * (1 - depth);
    final focus = Offset(size.width * .5, size.height * .42 + drift);
    canvas.drawCircle(
      focus,
      size.shortestSide * .92,
      Paint()
        ..shader = ui.Gradient.radial(
          focus,
          size.shortestSide * .92,
          [
            EntryPalette.blue.withValues(alpha: .10 * depth),
            EntryPalette.blue.withValues(alpha: .03 * depth),
            const Color(0x00000000),
          ],
          const [0, .45, 1],
        ),
    );

    // Faint curved geometry: two wide arcs echoing the balance hero's radius.
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = EntryPalette.blueSoft.withValues(alpha: .05 * depth);
    for (final (scale, offset) in [(1.35, .30), (1.9, .78)]) {
      final radius = size.width * scale;
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width * .5, size.height * offset + radius * .86),
          radius: radius,
        ),
        math.pi * 1.16,
        math.pi * .68,
        false,
        line,
      );
    }

    if (reducedMotion || sweep <= 0 || sweep >= 1) return;
    // One pass of soft light down the canvas while the system is loading.
    final y = size.height * (sweep * 1.4 - .2);
    final band = Rect.fromCenter(
      center: Offset(size.width * .5, y),
      width: size.width,
      height: size.height * .34,
    );
    canvas.drawRect(
      band,
      Paint()
        ..shader = ui.Gradient.linear(
          band.topCenter,
          band.bottomCenter,
          [
            const Color(0x00000000),
            EntryPalette.blue.withValues(
              alpha: .05 * math.sin(sweep * math.pi).clamp(0.0, 1.0),
            ),
            const Color(0x00000000),
          ],
          const [0, .5, 1],
        ),
    );
  }

  @override
  bool shouldRepaint(EntryEnvironmentPainter old) =>
      depth != old.depth ||
      sweep != old.sweep ||
      reducedMotion != old.reducedMotion;
}

/// The `d.` core signal: a thin icy ring with one travelling highlight and a
/// single pulse. Precise and system-like — deliberately not a chatbot orb.
class DuitlahSignalPainter extends CustomPainter {
  const DuitlahSignalPainter({
    required this.ring,
    required this.travel,
    required this.pulse,
    required this.reducedMotion,
  });

  /// How much of the ring has been drawn, from the top, clockwise.
  final double ring;

  /// Position of the single highlight travelling around the ring, 0 → 1.
  final double travel;

  /// One expanding pulse released when the ring closes.
  final double pulse;
  final bool reducedMotion;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 1;

    // Faint radial depth inside the ring gives the mark a material to sit on.
    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..shader = ui.Gradient.radial(
          centre,
          radius,
          [
            EntryPalette.blue.withValues(alpha: .10 * ring),
            EntryPalette.blue.withValues(alpha: .02 * ring),
            const Color(0x00000000),
          ],
          const [0, .62, 1],
        ),
    );

    if (pulse > 0 && pulse < 1 && !reducedMotion) {
      canvas.drawCircle(
        centre,
        radius * ui.lerpDouble(1, 1.34, Curves.easeOutCubic.transform(pulse))!,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = EntryPalette.blue.withValues(alpha: .22 * (1 - pulse)),
      );
    }

    if (ring <= 0) return;
    final circle = Rect.fromCircle(center: centre, radius: radius);
    const start = -math.pi / 2;
    canvas.drawArc(
      circle,
      start,
      math.pi * 2 * ring,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round
        ..color = EntryPalette.blue.withValues(alpha: .42),
    );

    if (reducedMotion || travel <= 0 || travel >= 1) return;
    // A short brighter segment runs the ring exactly once, then is gone.
    const span = math.pi * .38;
    final head = start + math.pi * 2 * travel;
    canvas.drawArc(
      circle,
      head - span,
      span,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          centre,
          [
            EntryPalette.blue.withValues(alpha: 0),
            EntryPalette.text.withValues(alpha: .85),
          ],
          const [0, 1],
          TileMode.clamp,
          head - span,
          head,
        ),
    );
  }

  @override
  bool shouldRepaint(DuitlahSignalPainter old) =>
      ring != old.ring ||
      travel != old.travel ||
      pulse != old.pulse ||
      reducedMotion != old.reducedMotion;
}

/// The `d.` mark inside its material field. Sized by [diameter] so the same
/// widget serves the loading signal and the smaller post-login confirmation.
class DuitlahSignal extends StatelessWidget {
  const DuitlahSignal({
    super.key,
    required this.ring,
    required this.travel,
    required this.pulse,
    required this.glyph,
    required this.reducedMotion,
    this.diameter = 88,
  });

  final double ring, travel, pulse, glyph, diameter;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: SizedBox.square(
      dimension: diameter,
      child: CustomPaint(
        painter: DuitlahSignalPainter(
          ring: ring,
          travel: travel,
          pulse: pulse,
          reducedMotion: reducedMotion,
        ),
        child: Center(
          child: Opacity(
            opacity: glyph.clamp(0, 1),
            child: Text(
              'd.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: EntryPalette.text,
                fontWeight: FontWeight.w600,
                fontSize: diameter * .34,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

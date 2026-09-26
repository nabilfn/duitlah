import 'package:flutter/material.dart';

import '../theme/duitlah_colors.dart';
import 'editorial_surfaces.dart';

/// One-shot paint reveal: no timers, loops, or offscreen animation controllers.
class DuitlahReveal extends StatelessWidget {
  const DuitlahReveal({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 420),
    curve: EditorialMotion.curve,
    child: child,
    builder: (context, value, child) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 12 * (1 - value)),
        child: child,
      ),
    ),
  );
}

/// A fixed hit area with a small, reversible material response to touch.
class DuitlahPress extends StatefulWidget {
  const DuitlahPress({super.key, required this.child, this.enabled = true});
  final Widget child;
  final bool enabled;
  @override
  State<DuitlahPress> createState() => _DuitlahPressState();
}

class _DuitlahPressState extends State<DuitlahPress> {
  bool pressed = false;
  void update(bool value) {
    if (pressed != value) setState(() => pressed = value);
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: widget.enabled ? (_) => update(true) : null,
    onPointerUp: (_) => update(false),
    onPointerCancel: (_) => update(false),
    child: AnimatedScale(
      scale:
          pressed && widget.enabled && !MediaQuery.disableAnimationsOf(context)
          ? .985
          : 1,
      duration: EditorialMotion.of(context),
      curve: EditorialMotion.curve,
      child: widget.child,
    ),
  );
}

/// A static precision texture; isolated from scrolling and text repaints.
class DuitlahSignalField extends StatelessWidget {
  const DuitlahSignalField({
    super.key,
    required this.child,
    this.onDark = false,
  });
  final Widget child;
  final bool onDark;
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _SignalPainter(
      onDark
          ? context.duitlahColors.balanceHighlight
          : context.duitlahColors.primary,
    ),
    child: child,
  );
}

class _SignalPainter extends CustomPainter {
  const _SignalPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: .14);
    for (double x = size.width * .55; x < size.width - 12; x += 18) {
      for (double y = 20; y < size.height - 16; y += 18) {
        canvas.drawCircle(Offset(x, y), .7, paint);
      }
    }
    paint
      ..color = color.withValues(alpha: .22)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width * .73, 20),
      Offset(size.width - 24, 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SignalPainter oldDelegate) => color != oldDelegate.color;
}

/// A labelled ratio path, never a simulated time series or investment chart.
class DuitlahTrajectory extends StatelessWidget {
  const DuitlahTrajectory({
    super.key,
    required this.progress,
    required this.label,
    this.onDark = false,
  });
  final double progress;
  final String label;
  final bool onDark;
  @override
  Widget build(BuildContext context) {
    final colors = context.duitlahColors;
    return Semantics(
      label: label,
      image: true,
      child: ExcludeSemantics(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress.clamp(0, 1)),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 520),
          curve: EditorialMotion.curve,
          builder: (_, value, _) => RepaintBoundary(
            child: SizedBox(
              height: 72,
              width: double.infinity,
              child: CustomPaint(
                painter: _TrajectoryPainter(
                  value,
                  onDark ? colors.balanceHighlight : colors.primary,
                  onDark
                      ? colors.balanceHighlight.withValues(alpha: .18)
                      : colors.border,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrajectoryPainter extends CustomPainter {
  const _TrajectoryPainter(this.progress, this.ink, this.track);
  final double progress;
  final Color ink, track;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(6, size.height * .8)
      ..cubicTo(
        size.width * .32,
        size.height * .85,
        size.width * .56,
        size.height * .12,
        size.width - 6,
        size.height * .2,
      );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = track;
    canvas.drawPath(path, paint);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      paint..color = ink,
    );
    final position = metric
        .getTangentForOffset(metric.length * progress)
        ?.position;
    if (position != null) {
      canvas.drawCircle(
        position,
        9,
        Paint()..color = ink.withValues(alpha: .12),
      );
      canvas.drawCircle(position, 3.5, Paint()..color = ink);
    }
  }

  @override
  bool shouldRepaint(_TrajectoryPainter old) =>
      progress != old.progress || ink != old.ink || track != old.track;
}

class DuitlahEditorialLink extends StatelessWidget {
  const DuitlahEditorialLink({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => DuitlahPress(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(subtitle),
      ),
      trailing: const Text('↗', style: TextStyle(fontSize: 22)),
      onTap: onTap,
    ),
  );
}

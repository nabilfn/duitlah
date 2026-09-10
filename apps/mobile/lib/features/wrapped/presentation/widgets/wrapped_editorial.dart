import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/duitlah_colors.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/duitlah_icon.dart';

/// Fixed chapter art direction, intentionally independent of the surrounding app brightness.
abstract final class WrappedPalette {
  static final cream = DuitlahColors.light.background;
  static final plum = DuitlahColors.light.primaryDark;
  static final ink = DuitlahColors.light.primaryDark;
  static final white = DuitlahColors.light.textOnPrimary;
  static final muted = DuitlahColors.light.textSecondary;
  static final card = DuitlahColors.light.surfaceSecondary;
  static final gold = Color.lerp(
    DuitlahColors.light.warning,
    DuitlahColors.light.primaryDark,
    .25,
  )!;
  static final goldPaper = Color.lerp(
    cream,
    DuitlahColors.light.warningSoft,
    .55,
  )!;
  static final sagePaper = Color.lerp(
    cream,
    DuitlahColors.light.positiveSoft,
    .4,
  )!;
  static ThemeData get theme =>
      AppTheme.light().copyWith(scaffoldBackgroundColor: cream);
  static TextStyle display(double size, {Color? color}) => TextStyle(
    fontFamily: 'Bodoni Moda',
    fontWeight: FontWeight.w400,
    fontSize: size,
    height: 1.02,
    letterSpacing: -1.4,
    color: color ?? ink,
  );
}

class WrappedEyebrow extends StatelessWidget {
  const WrappedEyebrow(this.text, {super.key, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 11,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w600,
      color: color ?? WrappedPalette.muted,
    ),
  );
}

class WrappedEntrance extends StatelessWidget {
  const WrappedEntrance({
    super.key,
    required this.visible,
    required this.child,
  });
  final bool visible;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return ExcludeSemantics(
      excluding: !visible,
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, .035),
          duration: Duration(milliseconds: reduced ? 0 : 380),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: Duration(milliseconds: reduced ? 0 : 380),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AnimatedMoney extends StatelessWidget {
  const AnimatedMoney(
    this.amount, {
    super.key,
    required this.style,
    this.animate = true,
  });
  final String amount;
  final TextStyle style;
  final bool animate;
  @override
  Widget build(BuildContext context) => Semantics(
    label: Money.format(amount),
    excludeSemantics: true,
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: animate ? 0 : 1, end: 1),
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) || !animate
            ? 0
            : 700,
      ),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => Text(
        t == 1
            ? Money.format(amount)
            : Money.format(
                ((double.tryParse(amount) ?? 0) * t).toStringAsFixed(2),
              ),
        style: style,
      ),
    ),
  );
}

class WrappedPill extends StatelessWidget {
  const WrappedPill(
    this.label, {
    super.key,
    required this.onPressed,
    this.dark = false,
    this.outlined = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool dark, outlined;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: dark && outlined
          ? WrappedPalette.white
          : (dark ? WrappedPalette.plum : WrappedPalette.white),
      backgroundColor: outlined
          ? Colors.transparent
          : (dark ? WrappedPalette.white : WrappedPalette.plum),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      minimumSize: const Size(48, 48),
      shape: StadiumBorder(
        side: outlined
            ? BorderSide(
                color: dark
                    ? WrappedPalette.white.withValues(alpha: .4)
                    : WrappedPalette.muted,
              )
            : BorderSide.none,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          DuitlahIcon(icon!, size: 18),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class WrappedTile extends StatelessWidget {
  const WrappedTile({
    super.key,
    required this.child,
    this.onTap,
    this.expanded,
    this.dark = false,
  });
  final Widget child;
  final Widget? expanded;
  final VoidCallback? onTap;
  final bool dark;
  @override
  Widget build(BuildContext context) => Material(
    color: dark
        ? WrappedPalette.white.withValues(alpha: .07)
        : WrappedPalette.card.withValues(alpha: .72),
    borderRadius: BorderRadius.circular(20),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            child,
            WrappedResize(
              duration: Duration(
                milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 220,
              ),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: expanded ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ),
  );
}

class WrappedBackdrop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = WrappedPalette.white.withValues(alpha: .065);
    canvas.drawOval(
      Rect.fromLTWH(
        -size.width * .7,
        size.height * .17,
        size.width * 1.55,
        size.height * .82,
      ),
      paint,
    );
    final path = Path()
      ..moveTo(size.width * .47, size.height)
      ..cubicTo(
        size.width * .8,
        size.height * .88,
        size.width * .59,
        size.height * .78,
        size.width,
        size.height * .66,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WrappedBackdrop oldDelegate) => false;
}

/// Avoid a zero-duration AnimatedSize layout mutation when reduced motion is on.
class WrappedResize extends StatelessWidget {
  const WrappedResize({
    super.key,
    required this.child,
    required this.duration,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
  });
  final Widget child;
  final Duration duration;
  final Curve curve;
  final AlignmentGeometry alignment;
  @override
  Widget build(BuildContext context) => MediaQuery.disableAnimationsOf(context)
      ? child
      : AnimatedSize(
          duration: duration,
          curve: curve,
          alignment: alignment,
          child: child,
        );
}

import 'package:flutter/material.dart';

import '../theme/glass_tokens.dart';
import '../theme/app_motion.dart';
import '../theme/glass_accessibility.dart';

abstract final class EditorialMotion {
  static const duration = AppMotion.control;
  static const curve = AppMotion.curve;
  static Duration of(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}

/// A bounded floating material. Matte content should not use this primitive.
class DuitlahGlassSurface extends StatelessWidget {
  const DuitlahGlassSurface({
    super.key,
    required this.child,
    this.radius = GlassTokens.radius,
    this.blur = true,
    this.material = GlassMaterial.standard,
    this.pressed = false,
    this.elevated = false,
    this.active = false,
  });
  final Widget child;
  final double radius;
  final bool blur, pressed, elevated, active;
  final GlassMaterial material;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final solid = GlassTransparencyScope.reducedOf(context);
    final shape = BorderRadius.circular(radius);
    final fill = GlassTokens.background(
      dark,
      material,
      pressed: pressed || active,
      solid: solid,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: elevated && !solid
            ? [GlassTokens.shadow(dark, pressed)]
            : null,
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          enabled: blur && !solid,
          filter: GlassTokens.filter(material, pressed || active),
          child: DecoratedBox(
            decoration: BoxDecoration(
              // The gradient already includes the material opacity. A paint
              // color here would multiply its alpha a second time.
              color: solid ? fill : null,
              borderRadius: shape,
              border: Border.all(color: GlassTokens.border(dark, material)),
              gradient: solid
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.alphaBlend(
                          Colors.white.withValues(
                            alpha: dark || material == GlassMaterial.hero
                                ? .025
                                : .10,
                          ),
                          fill,
                        ),
                        Color.alphaBlend(
                          Colors.white.withValues(alpha: .005),
                          fill,
                        ),
                      ],
                    ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: radius * .6,
                  right: radius * .6,
                  height: 1,
                  child: ColoredBox(
                    color: GlassTokens.highlight(dark, material),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The material itself responds to press/focus, without changing its hit area.
class DuitlahGlassButton extends StatefulWidget {
  const DuitlahGlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.material = GlassMaterial.standard,
    this.radius = 16,
    this.blur = true,
    this.elevated = true,
    this.label,
  });
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final GlassMaterial material;
  final double radius;
  final bool blur, elevated;
  final String? label;
  @override
  State<DuitlahGlassButton> createState() => _DuitlahGlassButtonState();
}

class _DuitlahGlassButtonState extends State<DuitlahGlassButton> {
  bool _pressed = false, _focused = false;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: widget.label,
    child: AnimatedScale(
      scale: _pressed && !MediaQuery.disableAnimationsOf(context) ? .98 : 1,
      duration: EditorialMotion.of(context),
      curve: EditorialMotion.curve,
      child: DuitlahGlassSurface(
        radius: widget.radius,
        material: widget.material,
        blur: widget.blur,
        elevated: widget.elevated,
        pressed: _pressed,
        active: _focused,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: BorderRadius.circular(widget.radius),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Bypass size animation entirely for reduced motion. A zero-duration
/// AnimatedSize can re-enter layout while its child changes asynchronously.
class DuitlahExpand extends StatelessWidget {
  const DuitlahExpand({
    super.key,
    required this.child,
    this.duration = EditorialMotion.duration,
    this.curve = EditorialMotion.curve,
    this.alignment = Alignment.topCenter,
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

class DuitlahGlassSheet extends StatelessWidget {
  const DuitlahGlassSheet({
    super.key,
    required this.child,
    this.showDragHandle = true,
  });
  final Widget child;
  final bool showDragHandle;
  @override
  Widget build(BuildContext context) => DuitlahGlassSurface(
    material: GlassMaterial.strong,
    radius: 24,
    elevated: true,
    child: Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: showDragHandle ? 28 : 0),
            child: child,
          ),
          if (showDragHandle)
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant
                          .withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// The panel's layout stays at its final size while the material aperture grows
/// from the dock. It clips rather than shrinking or reflowing the conversation.
class DuitlahAssistantExpansion extends StatelessWidget {
  const DuitlahAssistantExpansion({
    super.key,
    required this.animation,
    required this.child,
    this.origin,
  });
  final Animation<double> animation;
  final Widget child;
  final Rect? origin;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return LayoutBuilder(
      builder: (context, constraints) {
        final target = Rect.fromLTWH(
          0,
          constraints.maxHeight * .06,
          constraints.maxWidth,
          constraints.maxHeight * .94,
        );
        final start =
            origin ??
            Rect.fromLTWH(
              constraints.maxWidth - 170,
              constraints.maxHeight - 128,
              154,
              48,
            );
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final t = EditorialMotion.curve.transform(animation.value);
            final rect = Rect.lerp(start, target, t)!;
            return Stack(
              children: [
                Positioned.fromRect(
                  rect: rect,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16 + 8 * t),
                    child: OverflowBox(
                      alignment: Alignment.bottomRight,
                      minWidth: constraints.maxWidth,
                      maxWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                      maxHeight: constraints.maxHeight,
                      child: Opacity(
                        opacity: animation.value.clamp(0, 1),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

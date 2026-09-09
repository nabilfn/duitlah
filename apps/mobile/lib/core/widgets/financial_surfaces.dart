import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'duitlah_icon.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
    ],
  );
}

class FinancialModule extends StatelessWidget {
  const FinancialModule({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.color,
    this.compact = false,
  });
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest
        : color ?? const Color(0xFFECF0EA);
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DuitlahIcon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(height: 12),
                    Text(title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                )
              : Row(
                  children: [
                    DuitlahIcon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text(subtitle, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const DuitlahIcon(Icons.chevron_right, size: 18),
                  ],
                ),
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.sage,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: DuitlahIcon(icon, color: AppColors.forest, size: 25),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

/// Quiet botanical arcs, painted in code so they remain sharp and inexpensive.
class ForestSurface extends StatelessWidget {
  const ForestSurface({super.key, required this.child, this.radius = 0});
  final Widget child;
  final double radius;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: ColoredBox(
      color: AppColors.forest,
      child: CustomPaint(painter: _ForestPainter(), child: child),
    ),
  );
}

class _ForestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF92BCAA).withValues(alpha: .16);
    canvas.drawOval(
      Rect.fromLTWH(
        -size.width * .4,
        -size.height * .9,
        size.width * 1.35,
        size.height * 1.8,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .65,
        size.height * .45,
        size.width * .65,
        size.height,
      ),
      paint,
    );
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .64,
        size.height * .44,
        size.width * .65,
        size.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ForestPainter oldDelegate) => false;
}

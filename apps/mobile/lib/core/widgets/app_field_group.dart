import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Labels occupy their own row, so selected dropdown values, empty inputs and
/// multiline fields share the same leading edge at every text scale.
class AppFieldGroup extends StatelessWidget {
  const AppFieldGroup({super.key, required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ExcludeSemantics(
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
      const SizedBox(height: AppSpacing.labelGap),
      Semantics(label: label, child: child),
    ],
  );
}

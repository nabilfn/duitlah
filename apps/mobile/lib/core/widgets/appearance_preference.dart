import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/appearance_provider.dart';
import 'dialogs.dart';
import 'duitlah_segmented_control.dart';

class AppearancePreference extends ConsumerWidget {
  const AppearancePreference({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Appearance', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 10),
        DuitlahSegmentedControl<ThemeMode>(
          segments: const [
            ButtonSegment(value: ThemeMode.light, label: Text('Light')),
            ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
            ButtonSegment(value: ThemeMode.system, label: Text('System')),
          ],
          selected: {ref.watch(appearanceProvider)},
          onSelectionChanged: (selected) async {
            try {
              await ref
                  .read(appearanceProvider.notifier)
                  .setMode(selected.first);
            } catch (_) {
              if (context.mounted) {
                showErrorSnackBar(
                  context,
                  'Could not save appearance. Please try again.',
                );
              }
            }
          },
        ),
      ],
    ),
  );
}

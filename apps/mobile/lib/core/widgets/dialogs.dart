import 'package:flutter/material.dart';

import 'editorial_surfaces.dart';
import '../theme/glass_tokens.dart';
import '../theme/app_motion.dart';
import 'duitlah_icon.dart';

/// Confirms an irreversible or financially-consequential action
/// (finalize a bill, cancel a settlement, delete an item) before it fires.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  bool destructive = false,
}) async {
  final theme = Theme.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: DuitlahGlassSurface(
        material: GlassMaterial.strong,
        elevated: true,
        radius: 24,
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Text(message, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  OverflowBar(
                    alignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        style: destructive
                            ? FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                              )
                            : null,
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(confirmLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  return result ?? false;
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Semantics(liveRegion: true, child: Text(message))),
    );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Semantics(
          liveRegion: true,
          child: Row(
            children: [
              const DuitlahIcon(Icons.check_circle_outline, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
}

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showDuitlahGlassSheet<T>(context: context, builder: builder);

Future<T?> showDuitlahGlassSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool useSafeArea = true,
  bool showDragHandle = true,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  useSafeArea: useSafeArea,
  backgroundColor: Colors.transparent,
  elevation: 0,
  showDragHandle: false,
  sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
      ? AnimationStyle.noAnimation
      : AnimationStyle(
          duration: AppMotion.sheet,
          reverseDuration: AppMotion.control,
        ),
  builder: (context) => DuitlahGlassSheet(
    showDragHandle: showDragHandle,
    child: SafeArea(top: false, child: builder(context)),
  ),
);

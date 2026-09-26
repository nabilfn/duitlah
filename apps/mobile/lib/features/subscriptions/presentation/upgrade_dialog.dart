import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';

/// Shown when the backend rejects an action with `GROUP_LIMIT_REACHED` or
/// `RECEIPT_SCAN_LIMIT_REACHED` (see `SubscriptionService` on the backend) — a friendly paywall
/// moment rather than a raw error snackbar, per the product spec's "never destroy the social growth
/// loop through excessive paywalls" principle. Never blocks anything else in the app; this is the
/// only place a FREE-tier limit becomes visible.
Future<void> showUpgradeDialog(
  BuildContext context, {
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const DuitlahIcon(Icons.workspace_premium_outlined),
      title: const Text('Duitlah+'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.push(AppRoutes.duitlahPlus);
          },
          child: const Text('See plans'),
        ),
      ],
    ),
  );
}

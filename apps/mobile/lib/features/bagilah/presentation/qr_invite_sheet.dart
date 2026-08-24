import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/env.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/dialogs.dart';

/// Builds the exact same URL the web app's `buildBagilahInviteUrl` does
/// (`{webOrigin}/bagilah/join?token={token}`) — one invite surface for both
/// clients, reused for QR display and for the native share sheet. Guests
/// who don't have the app installed land on the Next.js web guest flow
/// when they open this link; the mandatory "never require app install"
/// requirement is satisfied by construction, not by a special case here.
class QrInviteSheet extends StatelessWidget {
  const QrInviteSheet({super.key, required this.token, required this.title});

  final String token;
  final String title;

  String get _link => '${Env.webBaseUrl}/bagilah/join?token=$token';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Anyone with this link or QR code can join — no account needed.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: QrImageView(data: _link, size: 200, backgroundColor: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copy link'),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: _link));
                    AppHaptics.qrScanSuccess();
                    if (context.mounted) showSuccessSnackBar(context, 'Link copied');
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Share'),
                  onPressed: () => Share.share(_link),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/env.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dialogs.dart';

/// Consolidates Phase 15's "help centre", "FAQ", "support channel", and
/// "feedback system" into one entry point rather than four separate More-menu
/// items. Help Centre/FAQ/Privacy/Terms are real content pages served by
/// `apps/web` (the same "web owns public/marketing surfaces, Flutter owns the
/// app's own features" split as the rest of this codebase) — this screen only
/// ever launches out to them; "Send feedback" is the one action that stays
/// in-app, since it's a real API call tied to the signed-in account.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _supportEmail = 'support@duitlah.app';

  Future<void> _open(BuildContext context, Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      showErrorSnackBar(context, 'Could not open ${uri.toString()}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.feedback_outlined,
        'Send feedback',
        'Report a bug or suggest an idea',
        () => context.push(AppRoutes.feedback),
      ),
      (
        Icons.help_outline,
        'Help Centre',
        'Guides for using Duitlah and Bagilah',
        () => _open(context, Uri.parse('${Env.webBaseUrl}/help')),
      ),
      (
        Icons.quiz_outlined,
        'FAQ',
        'Answers to common questions',
        () => _open(context, Uri.parse('${Env.webBaseUrl}/faq')),
      ),
      (
        Icons.mail_outline,
        'Contact support',
        _supportEmail,
        () => _open(context, Uri(scheme: 'mailto', path: _supportEmail)),
      ),
      (
        Icons.privacy_tip_outlined,
        'Privacy Policy',
        null,
        () => _open(context, Uri.parse('${Env.webBaseUrl}/privacy')),
      ),
      (
        Icons.description_outlined,
        'Terms of Service',
        null,
        () => _open(context, Uri.parse('${Env.webBaseUrl}/terms')),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: AppPageBody(
        child: ListView.separated(
          padding: AppSpacing.scrollInsets(context, floatingAction: false),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final (icon, title, subtitle, onTap) = items[index];
            return Card(
              child: ListTile(
                leading: DuitlahIcon(icon),
                title: Text(title),
                subtitle: subtitle == null ? null : Text(subtitle),
                trailing: const DuitlahIcon(Icons.chevron_right),
                onTap: onTap,
              ),
            );
          },
        ),
      ),
    );
  }
}

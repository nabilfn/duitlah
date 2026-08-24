import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/exports_providers.dart';

/// User-controlled exports (spec section 23) — implemented for the personal-finance data this app
/// has today: transactions, bills, loans, net worth, budgets, plus a full archive. See the
/// backend's `exports.package-info` for which of the spec's own broader export list (tax summary,
/// business accounting, Bagilah/Groups/settlements) is deliberately out of scope for this phase.
class ExportsScreen extends ConsumerStatefulWidget {
  const ExportsScreen({super.key});

  @override
  ConsumerState<ExportsScreen> createState() => _ExportsScreenState();
}

class _ExportsScreenState extends ConsumerState<ExportsScreen> {
  bool _busy = false;

  Future<void> _run(Future<dynamic> Function() action) async {
    setState(() => _busy = true);
    try {
      final file = await action();
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Export failed.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final repo = ref.read(exportRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Export data')),
      body: AbsorbPointer(
        absorbing: _busy,
        child: Opacity(
          opacity: _busy ? 0.5 : 1,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _ExportTile(
                icon: Icons.receipt_long_outlined,
                title: 'Transactions (CSV)',
                onTap: () => _run(() => repo.transactions(
                      from: DateTime(now.year - 1, now.month, now.day).toIso8601String().split('T').first,
                      to: now.toIso8601String().split('T').first,
                    )),
              ),
              _ExportTile(
                icon: Icons.request_page_outlined,
                title: 'Bills (CSV)',
                onTap: () => _run(() => repo.bills()),
              ),
              _ExportTile(
                icon: Icons.account_balance_outlined,
                title: 'Loans (CSV)',
                onTap: () => _run(() => repo.loans()),
              ),
              _ExportTile(
                icon: Icons.trending_up_outlined,
                title: 'Net worth (CSV)',
                onTap: () => _run(() => repo.netWorth()),
              ),
              _ExportTile(
                icon: Icons.pie_chart_outline,
                title: 'Budgets — this month (CSV)',
                onTap: () => _run(() => repo.budgets(year: now.year, month: now.month)),
              ),
              const Divider(height: AppSpacing.xl),
              _ExportTile(
                icon: Icons.archive_outlined,
                title: 'Full account archive (ZIP)',
                onTap: () => _run(() => repo.fullArchive()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExportTile extends StatelessWidget {
  const _ExportTile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.ios_share),
        onTap: onTap,
      ),
    );
  }
}

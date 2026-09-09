import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../../business/application/business_providers.dart';
import '../../business/domain/banking.dart';
import '../application/reconciliation_providers.dart';
import '../domain/reconciliation.dart';

String _fmtInstant(String isoInstant) => isoInstant.length >= 10 ? isoInstant.substring(0, 10) : isoInstant;

ReconciliationSessionResponse? _findSession(List<ReconciliationSessionResponse>? sessions, String? sessionId) {
  if (sessions == null || sessionId == null) return null;
  for (final s in sessions) {
    if (s.id == sessionId) return s;
  }
  return null;
}

BusinessAccount? _findAccount(List<BusinessAccount> accounts, String accountId) {
  for (final a in accounts) {
    if (a.id == accountId) return a;
  }
  return null;
}

/// Landing screen for Phase 7 — reached from the Business Dashboard's
/// "Reconciliation" tile. Mirrors `autotrack/presentation/
/// statement_import_screen.dart`'s upload-then-list layout: an account
/// picker + "Choose file" action up top, past imports/sessions below.
class ReconciliationHubScreen extends ConsumerStatefulWidget {
  const ReconciliationHubScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<ReconciliationHubScreen> createState() => _ReconciliationHubScreenState();
}

class _ReconciliationHubScreenState extends ConsumerState<ReconciliationHubScreen> {
  bool _uploading = false;

  Future<void> _pickAndUpload(String businessAccountId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf'],
    );
    final path = result?.files.single.path;
    if (path == null) return;

    setState(() => _uploading = true);
    try {
      final import = await ref.read(reconciliationRepositoryProvider).uploadStatement(
            widget.spaceId,
            businessAccountId: businessAccountId,
            filePath: path,
          );
      ref.invalidate(statementImportListProvider(widget.spaceId));
      ref.invalidate(reconciliationSessionListProvider(widget.spaceId));
      if (!mounted) return;
      if (import.status == BusinessStatementImportStatus.FAILED) {
        showErrorSnackBar(context, import.errorMessage ?? 'Could not read this statement.');
        return;
      }
      final sessionId = import.reconciliationSessionId;
      showSuccessSnackBar(context, '${import.rowCount} lines found — let\'s reconcile them.');
      if (sessionId != null) {
        context.push(AppRoutes.reconciliationSession(widget.spaceId, sessionId));
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e is AppException ? e.message : 'Upload failed.');
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(businessAccountListProvider(widget.spaceId)).valueOrNull ?? const [];
    final activeAccounts = accounts.where((a) => !a.archived).toList();
    final imports = ref.watch(statementImportListProvider(widget.spaceId));
    final sessions = ref.watch(reconciliationSessionListProvider(widget.spaceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Reconciliation')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(statementImportListProvider(widget.spaceId));
          ref.invalidate(reconciliationSessionListProvider(widget.spaceId));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Upload a bank statement (CSV, XLSX, or PDF) and match each line '
              'against your books, line by line.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (activeAccounts.isEmpty)
              const Text('Add a business account first.')
            else
              _AccountPicker(
                accounts: activeAccounts,
                uploading: _uploading,
                onPick: _pickAndUpload,
              ),
            const SizedBox(height: AppSpacing.xl),
            Text('Past imports', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            imports.when(
              data: (items) => items.isEmpty
                  ? const EmptyView(icon: Icons.receipt_long_outlined, title: 'No statements imported yet')
                  : Column(
                      children: items.map((import) {
                        final session = _findSession(sessions.valueOrNull, import.reconciliationSessionId);
                        final account = _findAccount(accounts, import.businessAccountId);
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: ListTile(
                            title: Text(import.originalFilename),
                            subtitle: Text(
                              '${account?.name ?? 'Unknown account'}'
                              '${session != null ? ' · ${_fmtInstant(session.startedAt)}' : ''}',
                            ),
                            trailing: _StatusChip(import: import, session: session),
                            onTap: session != null
                                ? () => context.push(AppRoutes.reconciliationSession(widget.spaceId, session.id))
                                : () => showErrorSnackBar(
                                      context,
                                      import.errorMessage ?? 'This import failed and has no session.',
                                    ),
                          ),
                        );
                      }).toList(),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(statementImportListProvider(widget.spaceId))),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.import, required this.session});

  final BusinessStatementImportResponse import;
  final ReconciliationSessionResponse? session;

  @override
  Widget build(BuildContext context) {
    if (import.status == BusinessStatementImportStatus.FAILED) {
      return Chip(
        label: const Text('FAILED'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        visualDensity: VisualDensity.compact,
      );
    }
    final label = session?.status.name ?? 'PARSED';
    final color = session?.status == ReconciliationSessionStatus.COMPLETED
        ? Colors.green.withValues(alpha: 0.15)
        : Theme.of(context).colorScheme.primaryContainer;
    return Chip(label: Text(label), backgroundColor: color, visualDensity: VisualDensity.compact);
  }
}

class _AccountPicker extends StatefulWidget {
  const _AccountPicker({required this.accounts, required this.uploading, required this.onPick});

  final List<BusinessAccount> accounts;
  final bool uploading;
  final void Function(String businessAccountId) onPick;

  @override
  State<_AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<_AccountPicker> {
  late String _accountId = widget.accounts.first.id;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: _accountId,
          decoration: const InputDecoration(labelText: 'Which account is this statement for?'),
          items: widget.accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
          onChanged: (v) => setState(() => _accountId = v ?? _accountId),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: widget.uploading ? 'Uploading…' : 'Import statement',
          onPressed: widget.uploading ? null : () => widget.onPick(_accountId),
        ),
      ],
    );
  }
}

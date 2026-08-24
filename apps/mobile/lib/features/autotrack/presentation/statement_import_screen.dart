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
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../application/autotrack_providers.dart';
import '../domain/transaction_candidate.dart';

/// Upload -> parse -> normalize -> AutoTrack review (spec section 13). There
/// is no separate "raw parsed rows" screen here — the candidates list
/// (reached automatically after a successful upload) already is that
/// review step.
class StatementImportScreen extends ConsumerStatefulWidget {
  const StatementImportScreen({super.key});

  @override
  ConsumerState<StatementImportScreen> createState() => _StatementImportScreenState();
}

class _StatementImportScreenState extends ConsumerState<StatementImportScreen> {
  bool _uploading = false;

  Future<void> _pickAndUpload(String accountId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf'],
    );
    final path = result?.files.single.path;
    if (path == null) return;

    setState(() => _uploading = true);
    try {
      final import = await ref.read(autoTrackRepositoryProvider).uploadStatement(
            accountId: accountId,
            filePath: path,
          );
      ref.invalidate(statementImportsProvider);
      if (!mounted) return;
      if (import.status == StatementImportStatus.FAILED) {
        showErrorSnackBar(context, import.errorMessage ?? 'Could not read this statement.');
        return;
      }
      ref.invalidate(pendingCandidatesProvider);
      if (!mounted) return;
      showSuccessSnackBar(context, '${import.rowCount} transactions found — review them below.');
      context.push(AppRoutes.autoTrackReview);
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
    final accounts = ref.watch(accountListProvider).valueOrNull ?? const [];
    final imports = ref.watch(statementImportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Import statement')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Upload a CSV, XLSX, or PDF export from your bank, and Duitlah will '
            'suggest transactions for you to review.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (accounts.isEmpty)
            const Text('Add an account first.')
          else
            _AccountPicker(
              accounts: accounts,
              uploading: _uploading,
              onPick: _pickAndUpload,
            ),
          const SizedBox(height: AppSpacing.xl),
          Text('Recent imports', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          imports.when(
            data: (items) => items.isEmpty
                ? const Text('No imports yet.')
                : Column(
                    children: items
                        .map(
                          (i) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(i.originalFilename),
                            subtitle: Text('${i.status.name} · ${i.rowCount} rows'),
                          ),
                        )
                        .toList(),
                  ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(statementImportsProvider)),
          ),
        ],
      ),
    );
  }
}

class _AccountPicker extends StatefulWidget {
  const _AccountPicker({required this.accounts, required this.uploading, required this.onPick});

  final List<Account> accounts;
  final bool uploading;
  final void Function(String accountId) onPick;

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
          initialValue: _accountId,
          decoration: const InputDecoration(labelText: 'Which account is this statement for?'),
          items: widget.accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
          onChanged: (v) => setState(() => _accountId = v ?? _accountId),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: widget.uploading ? 'Uploading…' : 'Choose file',
          onPressed: widget.uploading ? null : () => widget.onPick(_accountId),
        ),
      ],
    );
  }
}

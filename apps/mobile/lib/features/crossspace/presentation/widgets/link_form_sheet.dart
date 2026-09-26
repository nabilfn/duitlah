import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../accounting/application/accounting_providers.dart';
import '../../../accounting/domain/chart_of_accounts.dart';
import '../../../accounts/domain/finance.dart';
import '../../../business/application/business_providers.dart';
import '../../../business/domain/banking.dart';
import '../../application/cross_space_providers.dart';
import '../../domain/cross_space.dart';
import '../cross_space_labels.dart';
import 'personal_transaction_picker_sheet.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// One form for all four Cross-Space link actions — the fields overlap
/// enough (an existing Personal transaction, an amount, a date, an
/// optional description) that branching on [linkType] inside one sheet
/// reads better than four near-identical files, mirroring how
/// `asset_form_sheet.dart` reuses one sheet for create and edit. Only the
/// "posts to" picker differs: BUSINESS_ADVANCE picks a Chart-of-Accounts
/// *expense* account (which expense this was); the other three pick a
/// business bank/cash *account* (which account paid or received the cash)
/// — plus REIMBURSEMENT alone gets an optional picker over this business's
/// own prior BUSINESS_ADVANCE links, to name which one it settles.
class LinkFormSheet extends ConsumerStatefulWidget {
  const LinkFormSheet({
    super.key,
    required this.spaceId,
    required this.linkType,
  });

  final String spaceId;
  final CrossSpaceLinkType linkType;

  @override
  ConsumerState<LinkFormSheet> createState() => _LinkFormSheetState();
}

class _LinkFormSheetState extends ConsumerState<LinkFormSheet> {
  Transaction? _transaction;
  String? _chartOfAccountsId;
  String? _businessAccountId;
  String? _relatedLinkId;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _occurredOn = DateTime.now();
  bool _submitting = false;

  bool get _needsExpenseAccount =>
      widget.linkType == CrossSpaceLinkType.BUSINESS_ADVANCE;
  bool get _needsBusinessAccount => !_needsExpenseAccount;
  bool get _showsRelatedLink =>
      widget.linkType == CrossSpaceLinkType.REIMBURSEMENT;

  bool get _canSubmit =>
      !_submitting &&
      _transaction != null &&
      (!_needsExpenseAccount || _chartOfAccountsId != null) &&
      (!_needsBusinessAccount || _businessAccountId != null);

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickTransaction() async {
    final picked = await showAppBottomSheet<Transaction>(
      context,
      builder: (context) => const PersonalTransactionPickerSheet(),
    );
    if (picked != null) {
      setState(() {
        _transaction = picked;
        _amountController.text = picked.amount;
        _occurredOn = DateTime.tryParse(picked.occurredOn) ?? _occurredOn;
      });
    }
  }

  Future<void> _submit() async {
    final transaction = _transaction;
    final amount = _amountController.text.trim();
    if (transaction == null || amount.isEmpty) return;

    setState(() => _submitting = true);
    try {
      final repo = ref.read(crossSpaceRepositoryProvider);
      final description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();
      final occurredOn = _fmtDate(_occurredOn);

      if (widget.linkType == CrossSpaceLinkType.BUSINESS_ADVANCE) {
        await repo.createBusinessAdvance(
          widget.spaceId,
          personalTransactionId: transaction.id,
          expenseChartOfAccountsId: _chartOfAccountsId!,
          amount: amount,
          occurredOn: occurredOn,
          description: description,
        );
      } else if (widget.linkType == CrossSpaceLinkType.REIMBURSEMENT) {
        await repo.createReimbursement(
          widget.spaceId,
          personalTransactionId: transaction.id,
          businessAccountId: _businessAccountId!,
          relatedLinkId: _relatedLinkId,
          amount: amount,
          occurredOn: occurredOn,
          description: description,
        );
      } else if (widget.linkType == CrossSpaceLinkType.OWNER_CONTRIBUTION) {
        await repo.createOwnerContribution(
          widget.spaceId,
          personalTransactionId: transaction.id,
          businessAccountId: _businessAccountId!,
          amount: amount,
          occurredOn: occurredOn,
          description: description,
        );
      } else {
        await repo.createOwnerDrawing(
          widget.spaceId,
          personalTransactionId: transaction.id,
          businessAccountId: _businessAccountId!,
          amount: amount,
          occurredOn: occurredOn,
          description: description,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseAccounts = _needsExpenseAccount
        ? (ref.watch(chartOfAccountsListProvider(widget.spaceId)).valueOrNull ??
                  const <LedgerAccount>[])
              .where((a) => a.type == LedgerAccountType.EXPENSE && !a.archived)
              .toList()
        : const <LedgerAccount>[];
    final businessAccounts = _needsBusinessAccount
        ? (ref.watch(businessAccountListProvider(widget.spaceId)).valueOrNull ??
                  const <BusinessAccount>[])
              .where((a) => !a.archived)
              .toList()
        : const <BusinessAccount>[];
    final priorAdvances = _showsRelatedLink
        ? (ref.watch(crossSpaceLinkListProvider(widget.spaceId)).valueOrNull ??
                  const <CrossSpaceLinkResponse>[])
              .where((l) => l.linkType == CrossSpaceLinkType.BUSINESS_ADVANCE)
              .toList()
        : const <CrossSpaceLinkResponse>[];

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pageMargin,
        right: AppSpacing.pageMargin,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              crossSpaceLinkTypeLabel(widget.linkType),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              crossSpaceLinkTypeDescription(widget.linkType),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "This links a transaction you've already recorded in Personal — it never creates a new one.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              title: Text(
                _transaction == null
                    ? 'Select a personal transaction'
                    : (_transaction!.merchant ??
                          _transaction!.description ??
                          _transaction!.type.name),
              ),
              subtitle: _transaction == null
                  ? null
                  : Text(
                      'RM ${_transaction!.amount} · ${_transaction!.occurredOn}',
                    ),
              trailing: const DuitlahIcon(Icons.chevron_right),
              onTap: _pickTransaction,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_needsExpenseAccount) ...[
              AppFieldGroup(
                label: 'Expense account',
                child: DropdownButtonFormField<String>(
                  itemHeight: null,
                  icon: const DuitlahIcon(Icons.expand_more, size: 18),
                  initialValue: _chartOfAccountsId,
                  isExpanded: true,
                  decoration: const InputDecoration(),
                  items: expenseAccounts
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.id,
                          child: Text('${a.code} · ${a.name}'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _chartOfAccountsId = v),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (_needsBusinessAccount) ...[
              AppFieldGroup(
                label: 'Business account',
                child: DropdownButtonFormField<String>(
                  itemHeight: null,
                  icon: const DuitlahIcon(Icons.expand_more, size: 18),
                  initialValue: _businessAccountId,
                  isExpanded: true,
                  decoration: const InputDecoration(),
                  items: businessAccounts
                      .map(
                        (a) =>
                            DropdownMenuItem(value: a.id, child: Text(a.name)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _businessAccountId = v),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (_showsRelatedLink) ...[
              AppFieldGroup(
                label: 'Settles which advance? (optional)',
                child: DropdownButtonFormField<String?>(
                  itemHeight: null,
                  icon: const DuitlahIcon(Icons.expand_more, size: 18),
                  initialValue: _relatedLinkId,
                  isExpanded: true,
                  decoration: const InputDecoration(),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Not linked to a specific advance'),
                    ),
                    ...priorAdvances.map(
                      (l) => DropdownMenuItem<String?>(
                        value: l.id,
                        child: Text(
                          '${Money.format(l.amount)}${l.description != null ? ' · ${l.description}' : ''}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _relatedLinkId = v),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            AppTextField(
              label: 'Amount (RM)',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(_fmtDate(_occurredOn)),
              trailing: const DuitlahIcon(Icons.calendar_month_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _occurredOn,
                  firstDate: DateTime(_occurredOn.year - 5),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _occurredOn = picked);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Description (optional)',
              controller: _descriptionController,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: crossSpaceLinkTypeLabel(widget.linkType),
              loading: _submitting,
              onPressed: _canSubmit ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}

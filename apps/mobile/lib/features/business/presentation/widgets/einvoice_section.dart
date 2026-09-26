import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../application/business_providers.dart';
import '../../domain/sales.dart';

String _fmtInstant(String? isoInstant) => isoInstant == null
    ? '-'
    : (isoInstant.length >= 10 ? isoInstant.substring(0, 10) : isoInstant);

/// A small status-driven card attached to [InvoiceDetailScreen] for Phase 10
/// — LHDN / MyInvois e-Invoice submission. Reads as a natural extension of
/// the invoice detail page rather than a separate route (the invoice detail
/// screen isn't complex enough to warrant splitting this out), mirroring
/// `asset_detail_screen.dart`'s pattern of only showing the action(s) valid
/// from the current state — e.g. "Submit" never shows once already
/// SUBMITTED, "Cancel"/"Reject" only ever show from VALID.
class EInvoiceSection extends ConsumerWidget {
  const EInvoiceSection({
    super.key,
    required this.spaceId,
    required this.invoiceId,
  });

  final String spaceId;
  final String invoiceId;

  SpaceResourceKey get _key => (spaceId: spaceId, resourceId: invoiceId);

  void _invalidate(WidgetRef ref) {
    ref.invalidate(einvoiceProvider(_key));
    ref.invalidate(einvoiceLogsProvider(_key));
  }

  Future<void> _prepare(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(salesRepositoryProvider)
          .prepareEInvoice(spaceId, invoiceId);
      _invalidate(ref);
      if (context.mounted) {
        showSuccessSnackBar(context, 'Ready to submit as e-Invoice.');
      }
    } catch (e) {
      if (!context.mounted) return;
      final message = switch (e is AppException ? e.code : null) {
        'INVOICE_NOT_ISSUED' => 'This invoice must be issued (sent) before it can be submitted as an e-Invoice.',
        'EINVOICE_SELLER_TIN_MISSING' =>
          "Your business needs a TIN before submitting e-Invoices.",
        'EINVOICE_BUYER_TIN_MISSING' => 'This customer needs a TIN before you can submit an e-Invoice for them.',
        'EINVOICE_ALREADY_IN_PROGRESS' =>
          'An e-Invoice is already in progress for this invoice.',
        _ => e is AppException ? e.message : 'Something went wrong.',
      };
      showErrorSnackBar(context, message);
      if (e is AppException && e.code == 'EINVOICE_SELLER_TIN_MISSING') {
        context.push(AppRoutes.businessProfile(spaceId));
      } else if (e is AppException && e.code == 'EINVOICE_BUYER_TIN_MISSING') {
        context.push(AppRoutes.businessCustomers(spaceId));
      }
    }
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(salesRepositoryProvider)
          .submitEInvoice(spaceId, invoiceId);
      _invalidate(ref);
      if (context.mounted) {
        showSuccessSnackBar(context, 'Submitted to MyInvois.');
      }
    } catch (e) {
      if (!context.mounted) return;
      if (e is AppException && e.code == 'EINVOICE_PROVIDER_UNAVAILABLE') {
        showErrorSnackBar(
          context,
          "MyInvois isn't connected yet — ask your admin to configure e-Invoice credentials.",
        );
      } else {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
      _invalidate(ref);
    }
  }

  Future<void> _syncStatus(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(salesRepositoryProvider)
          .syncEInvoiceStatus(spaceId, invoiceId);
      _invalidate(ref);
      if (context.mounted) showSuccessSnackBar(context, 'Status refreshed.');
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  Future<void> _cancelOrReject(
    BuildContext context,
    WidgetRef ref, {
    required bool cancel,
  }) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cancel ? 'Cancel e-Invoice' : 'Reject e-Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cancel
                  ? 'This is only possible within 72 hours of validation. After that, issue a credit note instead.'
                  : 'In normal LHDN usage this is buyer-initiated — use this only if you need to reject on their behalf.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppFieldGroup(
              label: 'Reason',
              child: TextField(
                controller: reasonController,
                maxLength: 300,
                maxLines: 3,
                decoration: const InputDecoration(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Back'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(cancel ? 'Cancel e-Invoice' : 'Reject'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      showErrorSnackBar(context, 'A reason is required.');
      return;
    }
    try {
      final repo = ref.read(salesRepositoryProvider);
      if (cancel) {
        await repo.cancelEInvoice(spaceId, invoiceId, reason: reason);
      } else {
        await repo.rejectEInvoice(spaceId, invoiceId, reason: reason);
      }
      _invalidate(ref);
      if (context.mounted) {
        showSuccessSnackBar(
          context,
          cancel ? 'e-Invoice cancelled.' : 'e-Invoice rejected.',
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      final message = switch (e is AppException ? e.code : null) {
        'EINVOICE_NOT_VALID' =>
          'Only a VALID e-Invoice can be ${cancel ? 'cancelled' : 'rejected'}.',
        'EINVOICE_WINDOW_EXPIRED' =>
          'The 72-hour window has passed — issue a credit note instead.',
        _ => e is AppException ? e.message : 'Something went wrong.',
      };
      showErrorSnackBar(context, message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final einvoice = ref.watch(einvoiceProvider(_key));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const DuitlahIcon(Icons.receipt_long_outlined),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'e-Invoice',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            einvoice.when(
              data: (doc) => doc == null
                  ? _NotStarted(onPrepare: () => _prepare(context, ref))
                  : _DocumentBody(
                      doc: doc,
                      onSubmit: () => _submit(context, ref),
                      onSyncStatus: () => _syncStatus(context, ref),
                      onCancel: () =>
                          _cancelOrReject(context, ref, cancel: true),
                      onReject: () =>
                          _cancelOrReject(context, ref, cancel: false),
                    ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: LoadingView(),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(einvoiceProvider(_key)),
              ),
            ),
            if (einvoice.valueOrNull != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _LogsExpansion(spaceId: spaceId, invoiceId: invoiceId),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotStarted extends StatelessWidget {
  const _NotStarted({required this.onPrepare});

  final VoidCallback onPrepare;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This invoice hasn\'t been submitted as an e-Invoice yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(label: 'Submit as e-Invoice', onPressed: onPrepare),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final EInvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (status) {
      EInvoiceStatus.READY => (
        'Ready to submit',
        theme.colorScheme.secondaryContainer,
      ),
      EInvoiceStatus.SUBMITTED => (
        'Submitted — awaiting validation',
        theme.colorScheme.secondaryContainer,
      ),
      EInvoiceStatus.VALID => ('Valid', theme.colorScheme.primaryContainer),
      EInvoiceStatus.INVALID => ('Invalid', theme.colorScheme.errorContainer),
      EInvoiceStatus.CANCELLED => (
        'Cancelled',
        theme.colorScheme.surfaceContainerHighest,
      ),
      EInvoiceStatus.REJECTED => ('Rejected', theme.colorScheme.errorContainer),
    };
    return Chip(
      label: Text(label),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DocumentBody extends StatelessWidget {
  const _DocumentBody({
    required this.doc,
    required this.onSubmit,
    required this.onSyncStatus,
    required this.onCancel,
    required this.onReject,
  });

  final EInvoiceDocument doc;
  final VoidCallback onSubmit;
  final VoidCallback onSyncStatus;
  final VoidCallback onCancel;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAdaptiveRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_StatusChip(status: doc.status)],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (doc.status == EInvoiceStatus.VALID) ...[
          if (doc.longId != null) _Field('Long ID (QR)', doc.longId!),
          if (doc.submissionUid != null)
            _Field('Submission UID', doc.submissionUid!),
          _Field('Validated on', _fmtInstant(doc.validatedAt)),
        ] else if (doc.status == EInvoiceStatus.INVALID) ...[
          _Field('Reason', doc.invalidReason ?? 'Not provided'),
        ] else if (doc.status == EInvoiceStatus.CANCELLED) ...[
          _Field('Cancelled on', _fmtInstant(doc.cancelledAt)),
          _Field('Reason', doc.cancellationReason ?? 'Not provided'),
        ] else if (doc.status == EInvoiceStatus.REJECTED) ...[
          _Field('Rejected on', _fmtInstant(doc.rejectedAt)),
          _Field('Reason', doc.rejectionReason ?? 'Not provided'),
        ],
        const SizedBox(height: AppSpacing.md),
        if (doc.status == EInvoiceStatus.READY)
          PrimaryButton(label: 'Submit to LHDN', onPressed: onSubmit)
        else if (doc.status == EInvoiceStatus.SUBMITTED)
          SecondaryButton(
            label: 'Check status',
            icon: Icons.refresh,
            onPressed: onSyncStatus,
          )
        else if (doc.status == EInvoiceStatus.VALID)
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.errorContainer,
                  ),
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(onPressed: onReject, child: const Text('Reject')),
            ],
          ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Secondary/collapsible interaction history — troubleshooting, not the
/// primary UI, so it's tucked into an [ExpansionTile] rather than shown
/// inline.
class _LogsExpansion extends ConsumerWidget {
  const _LogsExpansion({required this.spaceId, required this.invoiceId});

  final String spaceId;
  final String invoiceId;

  SpaceResourceKey get _key => (spaceId: spaceId, resourceId: invoiceId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: const Text('Activity log'),
        children: [
          Consumer(
            builder: (context, ref, _) {
              final logs = ref.watch(einvoiceLogsProvider(_key));
              return logs.when(
                data: (items) => items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Text('No activity yet.'),
                      )
                    : Column(
                        children: items.map((l) => _LogTile(entry: l)).toList(),
                      ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: LoadingView(),
                ),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(einvoiceLogsProvider(_key)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final EInvoiceLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: DuitlahIcon(
        entry.success ? Icons.check_circle_outline : Icons.error_outline,
        color: entry.success
            ? context.duitlahColors.positive
            : Theme.of(context).colorScheme.error,
        size: 20,
      ),
      title: Text(
        '${entry.operation.name}${entry.providerName != null ? ' · ${entry.providerName}' : ''}',
      ),
      subtitle: Text(
        '${_fmtInstant(entry.createdAt)}${entry.detail != null ? ' · ${entry.detail}' : ''}',
      ),
    );
  }
}

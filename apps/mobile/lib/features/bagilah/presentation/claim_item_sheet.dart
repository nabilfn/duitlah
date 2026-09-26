import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/participant_avatar.dart';
import '../application/bagilah_providers.dart';
import '../domain/bagilah_enums.dart';
import '../domain/bill.dart';

enum _ClaimMode { whole, equalSplit, custom }

/// Claiming is participant-gated, not owner-gated (docs/bagilah-engine.md's
/// Phase 7 note) — any participant, including a guest, can open this and
/// adjust any claim on the item, not only their own. The three actions
/// here ("claim whole," "split equally," "custom") are all just thin calls
/// into the backend's own claim endpoints; nothing here computes a share.
class ClaimItemSheet extends ConsumerStatefulWidget {
  const ClaimItemSheet({
    super.key,
    required this.billId,
    required this.item,
    required this.participants,
    this.guestToken,
  });

  final String billId;
  final ReceiptItem item;
  final List<Participant> participants;

  /// Non-null when the current user is a guest (uses the guest endpoints
  /// instead of the authenticated owner/participant ones).
  final String? guestToken;

  @override
  ConsumerState<ClaimItemSheet> createState() => _ClaimItemSheetState();
}

class _ClaimItemSheetState extends ConsumerState<ClaimItemSheet> {
  _ClaimMode _mode = _ClaimMode.whole;
  String? _selectedParticipantId;
  ClaimType _customType = ClaimType.PERCENTAGE;
  final _customValueController = TextEditingController();
  final Set<String> _equalSplitSelection = {};
  bool _submitting = false;

  bool get _isGuest => widget.guestToken != null;

  @override
  void initState() {
    super.initState();
    _selectedParticipantId = widget.participants.isNotEmpty
        ? widget.participants.first.id
        : null;
    _equalSplitSelection.addAll(widget.participants.map((p) => p.id));
  }

  @override
  void dispose() {
    _customValueController.dispose();
    super.dispose();
  }

  Future<void> _removeClaim(String claimId) async {
    try {
      if (_isGuest) {
        await ref
            .read(guestBagilahRepositoryProvider)
            .removeClaim(widget.guestToken!, widget.item.id, claimId);
      } else {
        await ref
            .read(bagilahRepositoryProvider)
            .removeClaim(widget.billId, widget.item.id, claimId);
      }
      _invalidate();
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  void _invalidate() {
    if (_isGuest) {
      ref.invalidate(guestBreakdownProvider(widget.guestToken!));
      ref.invalidate(
        guestBillItemClaimsProvider((widget.guestToken!, widget.item.id)),
      );
    } else {
      ref.invalidate(billBreakdownProvider(widget.billId));
      ref.invalidate(billItemClaimsProvider((widget.billId, widget.item.id)));
    }
  }

  Future<void> _submit() async {
    if (_selectedParticipantId == null && _mode != _ClaimMode.equalSplit) {
      return;
    }
    setState(() => _submitting = true);
    try {
      switch (_mode) {
        case _ClaimMode.whole:
          if (_isGuest) {
            await ref
                .read(guestBagilahRepositoryProvider)
                .addClaim(
                  widget.guestToken!,
                  itemId: widget.item.id,
                  participantId: _selectedParticipantId!,
                  claimType: ClaimType.QUANTITY,
                  value: widget.item.quantity,
                );
          } else {
            await ref
                .read(bagilahRepositoryProvider)
                .addClaim(
                  widget.billId,
                  widget.item.id,
                  participantId: _selectedParticipantId!,
                  claimType: ClaimType.QUANTITY,
                  value: widget.item.quantity,
                );
          }
        case _ClaimMode.equalSplit:
          if (_isGuest) {
            // Guests use the same per-item claim endpoint one participant
            // at a time — the equal-split convenience endpoint is only on
            // the authenticated owner/participant surface. A guest who
            // wants a full equal split should ask any real participant to
            // trigger it, or claim their own share directly.
            throw AppException.local(
              'NOT_SUPPORTED',
              'Ask a signed-in participant to split this item equally.',
            );
          }
          await ref
              .read(bagilahRepositoryProvider)
              .equalSplit(
                widget.billId,
                widget.item.id,
                _equalSplitSelection.toList(),
              );
        case _ClaimMode.custom:
          final value = _customValueController.text.trim();
          if (_isGuest) {
            await ref
                .read(guestBagilahRepositoryProvider)
                .addClaim(
                  widget.guestToken!,
                  itemId: widget.item.id,
                  participantId: _selectedParticipantId!,
                  claimType: _customType,
                  value: value,
                );
          } else {
            await ref
                .read(bagilahRepositoryProvider)
                .addClaim(
                  widget.billId,
                  widget.item.id,
                  participantId: _selectedParticipantId!,
                  claimType: _customType,
                  value: value,
                );
          }
      }
      AppHaptics.claimSuccess();
      _invalidate();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final claims = _isGuest
        ? ref.watch(
            guestBillItemClaimsProvider((widget.guestToken!, widget.item.id)),
          )
        : ref.watch(billItemClaimsProvider((widget.billId, widget.item.id)));
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.item.name, style: theme.textTheme.titleLarge),
            Text(
              'Qty ${widget.item.quantity} · ${Money.format(widget.item.totalPrice)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            claims.when(
              data: (list) => list.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Already claimed',
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ...list.map(
                          (c) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: ParticipantAvatar(
                              name: c.displayName,
                              size: 28,
                            ),
                            title: Text(c.displayName),
                            subtitle: Text('${c.claimType.name} · ${c.value}'),
                            trailing: IconButton(
                              icon: const DuitlahIcon(Icons.close, size: 18),
                              onPressed: () => _removeClaim(c.id),
                            ),
                          ),
                        ),
                        const Divider(height: AppSpacing.xl),
                      ],
                    ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
            DuitlahSegmentedControl<_ClaimMode>(
              segments: const [
                ButtonSegment(
                  value: _ClaimMode.whole,
                  label: Text('Whole item'),
                ),
                ButtonSegment(
                  value: _ClaimMode.equalSplit,
                  label: Text('Split equally'),
                ),
                ButtonSegment(value: _ClaimMode.custom, label: Text('Custom')),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_mode == _ClaimMode.equalSplit)
              Wrap(
                spacing: 8,
                children: widget.participants
                    .map(
                      (p) => FilterChip(
                        label: Text(p.displayName),
                        selected: _equalSplitSelection.contains(p.id),
                        onSelected: (sel) => setState(() {
                          if (sel) {
                            _equalSplitSelection.add(p.id);
                          } else {
                            _equalSplitSelection.remove(p.id);
                          }
                        }),
                      ),
                    )
                    .toList(),
              )
            else ...[
              AppFieldGroup(
                label: 'Participant',
                child: DropdownButtonFormField<String>(
                  itemHeight: null,
                  isExpanded: true,
                  icon: const DuitlahIcon(Icons.expand_more, size: 18),
                  initialValue: _selectedParticipantId,
                  decoration: const InputDecoration(),
                  items: widget.participants
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedParticipantId = v),
                ),
              ),
              if (_mode == _ClaimMode.custom) ...[
                const SizedBox(height: AppSpacing.md),
                DuitlahSegmentedControl<ClaimType>(
                  segments: const [
                    ButtonSegment(
                      value: ClaimType.PERCENTAGE,
                      label: Text('%'),
                    ),
                    ButtonSegment(
                      value: ClaimType.QUANTITY,
                      label: Text('Qty'),
                    ),
                    ButtonSegment(value: ClaimType.AMOUNT, label: Text('RM')),
                  ],
                  selected: {_customType},
                  onSelectionChanged: (s) =>
                      setState(() => _customType = s.first),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: switch (_customType) {
                    ClaimType.PERCENTAGE => 'Percentage (e.g. 50)',
                    ClaimType.QUANTITY => 'Quantity',
                    ClaimType.AMOUNT => 'Amount (RM)',
                  },
                  controller: _customValueController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Confirm claim',
              onPressed: _submit,
              loading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}

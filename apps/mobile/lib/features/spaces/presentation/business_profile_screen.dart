import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/spaces_providers.dart';
import '../domain/financial_space.dart';
import 'widgets/business_profile_form_sheet.dart';

final _businessProfileProvider = FutureProvider.autoDispose
    .family<BusinessProfile, String>((ref, spaceId) {
      return ref.watch(spacesRepositoryProvider).getBusinessProfile(spaceId);
    });

/// Read-only through Phase 9 — Phase 10 (LHDN / MyInvois / SST) adds the
/// first-ever edit path for this resource (a real server-enforced
/// `MANAGE_BOOKS` check on the `PUT`, never guessed client-side here, so the
/// edit action stays visible to everyone and only a genuine 403 blocks it)
/// plus the new [BusinessProfile.annualRevenue] field, which the Business
/// Tax e-Invoice-readiness check reads.
class BusinessProfileScreen extends ConsumerWidget {
  const BusinessProfileScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _openEditForm(
    BuildContext context,
    WidgetRef ref,
    BusinessProfile profile,
  ) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) =>
          BusinessProfileFormSheet(spaceId: spaceId, existing: profile),
    );
    if (saved == true) {
      ref.invalidate(_businessProfileProvider(spaceId));
      if (context.mounted) {
        showSuccessSnackBar(context, 'Business profile updated.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(_businessProfileProvider(spaceId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business profile'),
        actions: [
          if (profile.valueOrNull != null)
            IconButton(
              icon: const DuitlahIcon(Icons.edit_outlined),
              onPressed: () => _openEditForm(context, ref, profile.value!),
            ),
        ],
      ),
      body: profile.when(
        data: (p) => ListView(
          padding: AppSpacing.scrollInsets(context, floatingAction: false),
          children: [
            _Field('Legal name', p.legalName),
            _Field('Trade name', p.tradeName),
            _Field('Registration number', p.registrationNumber),
            _Field('TIN', p.tin),
            _Field('Business type', p.businessType),
            _Field('Industry', p.industry),
            _Field('SST number', p.sstNumber),
            _Field(
              'Annual revenue',
              p.annualRevenue != null ? Money.format(p.annualRevenue!) : null,
            ),
            _Field('Financial year start', p.financialYearStart),
            _Field('Financial year end', p.financialYearEnd),
            _Field('Currency', p.currency),
            _Field('Address', p.address),
            _Field('Phone', p.phone),
            _Field('Email', p.email),
          ],
        ),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(_businessProfileProvider(spaceId)),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            (value == null || value!.isEmpty) ? 'Not set' : value!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

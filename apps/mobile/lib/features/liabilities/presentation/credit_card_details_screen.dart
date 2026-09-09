import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/liabilities_providers.dart';
import '../domain/liability.dart';

/// Credit limit / statement dates / utilization for a CREDIT_CARD account (spec section 18).
/// Purchases and repayments are ordinary transactions/transfers on the account itself — this
/// screen only shows the derived numbers, never a second ledger.
class CreditCardDetailsScreen extends ConsumerWidget {
  const CreditCardDetailsScreen({super.key, required this.accountId, required this.accountName});

  final String accountId;
  final String accountName;

  Future<void> _setUp(BuildContext context, WidgetRef ref, CreditCardDetails? existing) async {
    final limitController = TextEditingController(text: existing?.creditLimit);
    final statementDayController = TextEditingController(text: existing?.statementDay.toString() ?? '1');
    final dueDayController = TextEditingController(text: existing?.paymentDueDay.toString() ?? '20');

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => SingleChildScrollView(child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Card details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Credit limit (RM)', controller: limitController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Statement day (1-28)', controller: statementDayController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Payment due day (1-28)', controller: dueDayController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Save',
              onPressed: () async {
                try {
                  await ref.read(creditCardRepositoryProvider).setDetails(
                        accountId,
                        creditLimit: limitController.text.trim(),
                        statementDay: int.parse(statementDayController.text.trim()),
                        paymentDueDay: int.parse(dueDayController.text.trim()),
                      );
                  if (context.mounted) Navigator.of(context).pop(true);
                } catch (e) {
                  if (context.mounted) {
                    showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
                  }
                }
              },
            ),
          ],
        ),
      )),
    );
    if (saved == true) ref.invalidate(creditCardDetailsProvider(accountId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(creditCardDetailsProvider(accountId));
    return Scaffold(
      appBar: AppBar(title: Text(accountName)),
      body: details.when(
        data: (d) => d == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Set up this card\'s credit limit and statement dates to see utilization.'),
                      const SizedBox(height: AppSpacing.md),
                      PrimaryButton(label: 'Set up card', onPressed: () => _setUp(context, ref, null)),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _Field('Current outstanding', 'RM ${d.currentOutstanding}'),
                  _Field('Available credit', 'RM ${d.availableCredit}'),
                  _Field('Utilization', '${(double.parse(d.utilization) * 100).toStringAsFixed(1)}%'),
                  _Field('Statement balance', 'RM ${d.statementBalance}'),
                  _Field('Minimum payment due', 'RM ${d.minimumPaymentDue}'),
                  _Field('Credit limit', 'RM ${d.creditLimit}'),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(label: 'Edit card details', onPressed: () => _setUp(context, ref, d)),
                ],
              ),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(creditCardDetailsProvider(accountId))),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

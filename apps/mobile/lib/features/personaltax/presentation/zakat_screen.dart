import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/personal_tax_providers.dart';

class ZakatScreen extends ConsumerWidget {
  const ZakatScreen({super.key});

  Future<void> _recordZakat(BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();
    final ya = ref.read(selectedYearOfAssessmentProvider);

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.pageMargin,
            right: AppSpacing.pageMargin,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Record zakat — YA $ya',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Amount (RM)',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Save',
                onPressed: () async {
                  try {
                    await ref
                        .read(personalTaxRepositoryProvider)
                        .recordZakat(
                          yearOfAssessment: ya,
                          amount: amountController.text.trim(),
                          paidOn: DateTime.now()
                              .toIso8601String()
                              .split('T')
                              .first,
                        );
                    if (context.mounted) Navigator.of(context).pop(true);
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackBar(
                        context,
                        e is AppException ? e.message : 'Something went wrong.',
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    if (saved == true) {
      ref.invalidate(zakatListProvider);
      ref.invalidate(personalTaxCalculationProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zakat = ref.watch(zakatListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat')),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(zakatListProvider),
          child: zakat.when(
            data: (items) => items.isEmpty
                ? ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: const [
                      SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.volunteer_activism_outlined,
                        title: 'No zakat recorded yet',
                      ),
                    ],
                  )
                : ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: AppSpacing.scrollInsets(
                      context,
                      floatingAction: true,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final payment = items[index];
                      return Card(
                        child: AppRecordTile(
                          title: Text(payment.paidOn),
                          trailing: Text(Money.format(payment.amount)),
                        ),
                      );
                    },
                  ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(zakatListProvider),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _recordZakat(context, ref),
        child: const DuitlahIcon(Icons.add),
      ),
    );
  }
}

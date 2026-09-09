import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/status_chip.dart';
import '../../recurring/domain/recurring_transaction.dart' show RecurrenceFrequency;
import '../application/business_providers.dart';
import '../domain/catalog.dart';
import '../domain/contacts.dart';
import '../domain/recurring_invoice.dart';
import 'widgets/line_items_editor.dart';

/// Recurring invoices (Phase 13) — a schedule that materializes an ordinary
/// DRAFT invoice every time it's due (see `RecurringInvoiceRepository`'s own
/// doc comment). Reached from the Business Dashboard rather than the global
/// More menu, matching this codebase's established rule that every
/// space-scoped business feature lives behind the dashboard.
class RecurringInvoicesScreen extends ConsumerWidget {
  const RecurringInvoicesScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _newSchedule(BuildContext context, WidgetRef ref) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _RecurringInvoiceFormSheet(spaceId: spaceId),
    );
    if (saved == true) ref.invalidate(recurringInvoiceListProvider(spaceId));
  }

  Future<void> _toggleActive(BuildContext context, WidgetRef ref, RecurringInvoice schedule) async {
    try {
      await ref.read(recurringInvoiceRepositoryProvider).setActive(spaceId, schedule.id, !schedule.active);
      ref.invalidate(recurringInvoiceListProvider(spaceId));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, RecurringInvoice schedule) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this schedule?',
      message: 'Invoices already materialized are kept — this only stops future ones.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(recurringInvoiceRepositoryProvider).delete(spaceId, schedule.id);
      ref.invalidate(recurringInvoiceListProvider(spaceId));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(recurringInvoiceListProvider(spaceId));
    final customers = ref.watch(customerListProvider(spaceId)).valueOrNull ?? const [];
    String customerName(String id) =>
        customers.where((c) => c.id == id).firstOrNull?.name ?? 'Unknown customer';

    return Scaffold(
      appBar: AppBar(title: const Text('Recurring Invoices')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(recurringInvoiceListProvider(spaceId)),
        child: schedules.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(
                      icon: Icons.event_repeat_outlined,
                      title: 'No recurring invoices yet',
                      message: 'Set up a schedule to auto-draft an invoice for a repeat customer.',
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final schedule = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(customerName(schedule.customerId)),
                        subtitle: Text(
                          '${schedule.frequency.name.toLowerCase()} · next ${schedule.nextOccurrenceDate}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!schedule.active)
                              Padding(
                                padding: EdgeInsets.only(right: AppSpacing.xs),
                                child: StatusChip(label: 'Paused', color: context.duitlahColors.textTertiary),
                              ),
                            IconButton(
                              icon: DuitlahIcon(schedule.active ? Icons.pause_circle_outline : Icons.play_circle_outline),
                              tooltip: schedule.active ? 'Pause' : 'Resume',
                              onPressed: () => _toggleActive(context, ref, schedule),
                            ),
                            IconButton(
                              icon: const DuitlahIcon(Icons.delete_outline, size: 18),
                              onPressed: () => _delete(context, ref, schedule),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(recurringInvoiceListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _newSchedule(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}

class _RecurringInvoiceFormSheet extends ConsumerStatefulWidget {
  const _RecurringInvoiceFormSheet({required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<_RecurringInvoiceFormSheet> createState() => _RecurringInvoiceFormSheetState();
}

class _RecurringInvoiceFormSheetState extends ConsumerState<_RecurringInvoiceFormSheet> {
  final _taxPercentController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  final _paymentTermDaysController = TextEditingController(text: '30');
  List<LineItemDraft> _lineItems = [LineItemDraft()];

  Customer? _customer;
  List<Customer> _customers = [];
  List<Product> _products = [];
  bool _loading = true;
  bool _submitting = false;

  RecurrenceFrequency _frequency = RecurrenceFrequency.MONTHLY;
  final _intervalCountController = TextEditingController(text: '1');
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final customers = await ref.read(contactsRepositoryProvider).listCustomers(widget.spaceId);
    final products = await ref.read(catalogRepositoryProvider).listProducts(widget.spaceId);
    if (!mounted) return;
    setState(() {
      _customers = customers;
      _products = products;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _taxPercentController.dispose();
    _notesController.dispose();
    _paymentTermDaysController.dispose();
    _intervalCountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_customer == null || _lineItems.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref.read(recurringInvoiceRepositoryProvider).create(
            widget.spaceId,
            customerId: _customer!.id,
            taxPercent: _taxPercentController.text.trim().isEmpty ? null : _taxPercentController.text.trim(),
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            paymentTermDays: int.tryParse(_paymentTermDaysController.text.trim()),
            frequency: _frequency,
            intervalCount: int.tryParse(_intervalCountController.text.trim()),
            startDate: _startDate.toIso8601String().split('T').first,
            endDate: _endDate?.toIso8601String().split('T').first,
            lineItems: _lineItems.map((e) => e.toInput()).toList(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: _loading
          ? const Padding(padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingView())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('New recurring invoice', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<Customer>(
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: _customer,
                    decoration: const InputDecoration(labelText: 'Customer'),
                    items: _customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                    onChanged: (v) => setState(() => _customer = v),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<RecurrenceFrequency>(
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: _frequency,
                    decoration: const InputDecoration(labelText: 'Repeats'),
                    items: RecurrenceFrequency.values
                        .map((f) => DropdownMenuItem(value: f, child: Text(f.name.toLowerCase())))
                        .toList(),
                    onChanged: (v) => setState(() => _frequency = v ?? _frequency),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Every N periods', controller: _intervalCountController, keyboardType: TextInputType.number),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    icon: const DuitlahIcon(Icons.calendar_today_outlined),
                    label: Text('Starts ${_startDate.toIso8601String().split('T').first}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _startDate = picked);
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    icon: const DuitlahIcon(Icons.event_busy_outlined),
                    label: Text(_endDate == null ? 'No end date' : 'Ends ${_endDate!.toIso8601String().split('T').first}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? _startDate.add(const Duration(days: 365)),
                        firstDate: _startDate,
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _endDate = picked);
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Payment term (days)', controller: _paymentTermDaysController, keyboardType: TextInputType.number),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Tax %', controller: _taxPercentController, keyboardType: TextInputType.number),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Notes (optional)', controller: _notesController),
                  const SizedBox(height: AppSpacing.md),
                  LineItemsEditor(
                    items: _lineItems,
                    products: _products,
                    onChanged: (items) => setState(() => _lineItems = items),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: 'Create schedule',
                    onPressed: _customer == null ? null : _submit,
                    loading: _submitting,
                  ),
                ],
              ),
            ),
    );
  }
}

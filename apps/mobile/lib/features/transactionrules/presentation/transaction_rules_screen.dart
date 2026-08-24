import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/status_chip.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../application/transaction_rule_providers.dart';
import '../domain/transaction_rule.dart';

/// Transaction rules (Phase 13) — the CRUD half of "automatic categorization":
/// the backend's `TransactionRuleService.suggestCategory` consults these
/// (highest-priority active rule wins) before falling back to its older
/// "last time you logged at this merchant" lookup. There's no "apply" action
/// here since the backend applies rules on its own whenever it produces an
/// AutoTrack suggestion — this screen is purely CRUD, same as any other list
/// feature in this app.
class TransactionRulesScreen extends ConsumerWidget {
  const TransactionRulesScreen({super.key});

  String _matchTypeLabel(MatchType type) => switch (type) {
        MatchType.MERCHANT_EQUALS => 'Merchant is exactly',
        MatchType.MERCHANT_CONTAINS => 'Merchant contains',
      };

  Future<void> _openForm(BuildContext context, WidgetRef ref, {TransactionRule? existing}) async {
    final categories = ref.read(categoryListProvider).valueOrNull ?? const [];
    if (categories.isEmpty) {
      showErrorSnackBar(context, 'Add a category first.');
      return;
    }
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _RuleFormSheet(existing: existing, categories: categories),
    );
    if (saved == true) ref.invalidate(transactionRuleListProvider);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, TransactionRule rule) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this rule?',
      message: 'Future AutoTrack suggestions at "${rule.matchValue}" will fall back to the default heuristic.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(transactionRuleRepositoryProvider).delete(rule.id);
      ref.invalidate(transactionRuleListProvider);
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(transactionRuleListProvider);
    final categories = ref.watch(categoryListProvider).valueOrNull ?? const [];
    String categoryName(String id) =>
        categories.where((c) => c.id == id).firstOrNull?.name ?? 'Unknown category';

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Rules')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(transactionRuleListProvider),
        child: rules.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(
                      icon: Icons.rule_outlined,
                      title: 'No rules yet',
                      message: 'Add a rule so AutoTrack picks the right category automatically, '
                          'or confirm a transaction once to let Duitlah learn one for you.',
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final rule = items[index];
                    return Card(
                      child: ListTile(
                        title: Text('${_matchTypeLabel(rule.matchType)} "${rule.matchValue}"'),
                        subtitle: Row(
                          children: [
                            Expanded(child: Text('→ ${categoryName(rule.categoryId)}  ·  priority ${rule.priority}')),
                          ],
                        ),
                        onTap: () => _openForm(context, ref, existing: rule),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (rule.learned)
                              const Padding(
                                padding: EdgeInsets.only(right: AppSpacing.xs),
                                child: StatusChip(label: 'Auto-learned', color: Colors.teal, icon: Icons.auto_awesome),
                              ),
                            if (!rule.active)
                              const Padding(
                                padding: EdgeInsets.only(right: AppSpacing.xs),
                                child: StatusChip(label: 'Inactive', color: Colors.grey),
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18),
                              onPressed: () => _delete(context, ref, rule),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(transactionRuleListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _openForm(context, ref), child: const Icon(Icons.add)),
    );
  }
}

class _RuleFormSheet extends ConsumerStatefulWidget {
  const _RuleFormSheet({this.existing, required this.categories});

  final TransactionRule? existing;
  final List<Category> categories;

  @override
  ConsumerState<_RuleFormSheet> createState() => _RuleFormSheetState();
}

class _RuleFormSheetState extends ConsumerState<_RuleFormSheet> {
  late final _matchValueController = TextEditingController(text: widget.existing?.matchValue ?? '');
  late final _priorityController =
      TextEditingController(text: (widget.existing?.priority ?? 0).toString());
  late MatchType _matchType = widget.existing?.matchType ?? MatchType.MERCHANT_EQUALS;
  late String _categoryId = widget.existing?.categoryId ?? widget.categories.first.id;
  late bool _active = widget.existing?.active ?? true;
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    _matchValueController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_matchValueController.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      final priority = int.tryParse(_priorityController.text.trim());
      if (_isEditing) {
        await ref.read(transactionRuleRepositoryProvider).update(
              widget.existing!.id,
              matchType: _matchType,
              matchValue: _matchValueController.text.trim(),
              categoryId: _categoryId,
              priority: priority ?? widget.existing!.priority,
              active: _active,
            );
      } else {
        await ref.read(transactionRuleRepositoryProvider).create(
              matchType: _matchType,
              matchValue: _matchValueController.text.trim(),
              categoryId: _categoryId,
              priority: priority,
            );
      }
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_isEditing ? 'Edit rule' : 'New rule', style: Theme.of(context).textTheme.titleLarge),
            if (widget.existing?.learned == true) ...[
              const SizedBox(height: 4),
              Text(
                'This rule was learned automatically from a confirmed transaction. Editing it works exactly '
                'like a rule you created yourself.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<MatchType>(
              initialValue: _matchType,
              decoration: const InputDecoration(labelText: 'Match type'),
              items: MatchType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t == MatchType.MERCHANT_EQUALS ? 'Merchant is exactly' : 'Merchant contains')))
                  .toList(),
              onChanged: (v) => setState(() => _matchType = v ?? _matchType),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Merchant text', controller: _matchValueController),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Category'),
              items: widget.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _categoryId = v ?? _categoryId),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Priority (higher wins ties)', controller: _priorityController, keyboardType: TextInputType.number),
            if (_isEditing) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: _isEditing ? 'Save' : 'Create', onPressed: _submit, loading: _submitting),
          ],
        ),
      ),
    );
  }
}

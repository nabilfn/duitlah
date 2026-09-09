import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../../core/widgets/duitlah_segmented_control.dart';
import '../application/finance_providers.dart';
import '../domain/finance.dart';

/// The same categories used by transaction entry, presented as a browsable list.
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});
  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  CategoryType _type = CategoryType.EXPENSE;
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: DuitlahSegmentedControl<CategoryType>(
              segments: const [
                ButtonSegment(
                  value: CategoryType.EXPENSE,
                  label: Text('Expenses'),
                ),
                ButtonSegment(
                  value: CategoryType.INCOME,
                  label: Text('Income'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
          ),
          Expanded(
            child: categories.when(
              data: (list) {
                final visible = list.where((c) => c.type == _type).toList();
                return visible.isEmpty
                    ? const EmptyView(
                        icon: Icons.pie_chart_outline,
                        title: 'No categories available',
                        message: 'Available categories will appear here and in transaction entry.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const Divider(indent: 48),
                        itemBuilder: (context, index) => ListTile(
                          leading: const DuitlahIcon(Icons.pie_chart_outline),
                          title: Text(visible[index].name),
                          subtitle: visible[index].custom
                              ? const Text('Custom category')
                              : null,
                        ),
                      );
              },
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(categoryListProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

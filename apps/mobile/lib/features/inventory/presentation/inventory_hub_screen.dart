import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/inventory_providers.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Landing screen for Phase 8 — Inventory & Costing, reached from the
/// Business Dashboard's "Inventory" tile. Combines the space-wide stock
/// valuation list (every `trackInventory`-enabled product) with a
/// COGS-by-date-range report on one hub — mirroring how
/// `reconciliation_hub_screen.dart` puts more than one concern on a single
/// hub rather than forcing a separate route per concern; the router only
/// gains this hub plus the per-product detail screen, same 2-route shape as
/// Phase 7.
class InventoryHubScreen extends ConsumerStatefulWidget {
  const InventoryHubScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<InventoryHubScreen> createState() => _InventoryHubScreenState();
}

class _InventoryHubScreenState extends ConsumerState<InventoryHubScreen> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = DateTime(now.year, now.month + 1, 0);
  }

  CogsFilter get _cogsFilter =>
      (spaceId: widget.spaceId, from: _fmtDate(_from), to: _fmtDate(_to));

  @override
  Widget build(BuildContext context) {
    final valuation = ref.watch(stockValuationListProvider(widget.spaceId));
    final cogs = ref.watch(cogsReportProvider(_cogsFilter));

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(stockValuationListProvider(widget.spaceId));
            ref.invalidate(cogsReportProvider(_cogsFilter));
          },
          child: ListView(
            padding: AppSpacing.scrollInsets(context, floatingAction: false),
            children: [
              Text(
                'Cost of Goods Sold',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(_from.year - 5),
                    lastDate: DateTime(_to.year + 5),
                    initialDateRange: DateTimeRange(start: _from, end: _to),
                  );
                  if (picked != null) {
                    setState(() {
                      _from = picked.start;
                      _to = picked.end;
                    });
                  }
                },
                child: Text('${_fmtDate(_from)} to ${_fmtDate(_to)}'),
              ),
              const SizedBox(height: AppSpacing.sm),
              cogs.when(
                data: (r) => Card(
                  child: AppRecordTile(
                    title: const Text('Total COGS'),
                    subtitle: Text('${r.from} to ${r.to}'),
                    trailing: Text(
                      Money.format(r.totalCogs),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () =>
                      ref.invalidate(cogsReportProvider(_cogsFilter)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Stock valuation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              valuation.when(
                data: (items) => items.isEmpty
                    ? const EmptyView(
                        icon: Icons.inventory_2_outlined,
                        title: 'No tracked products yet',
                        message: 'Turn on "Track inventory" on a product to see it here.',
                      )
                    : Column(
                        children: items
                            .map(
                              (row) => Card(
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: AppRecordTile(
                                  title: Text(row.productName),
                                  subtitle: Text(
                                    row.sku != null
                                        ? 'SKU ${row.sku} · Qty ${row.quantityOnHand}'
                                        : 'Qty ${row.quantityOnHand}',
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        Money.format(row.totalValue),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Text(
                                        'WAC ${row.weightedAverageCost}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  onTap: () => context.push(
                                    AppRoutes.inventoryProductDetail(
                                      widget.spaceId,
                                      row.productId,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(
                    stockValuationListProvider(widget.spaceId),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

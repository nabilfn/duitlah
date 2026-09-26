import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/sse_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/list_rows.dart';
import '../application/bagilah_providers.dart';
import '../data/guest_session_store.dart';
import 'claim_item_sheet.dart';

/// The guest experience: no login, no app-install requirement — opened via
/// the invite link/QR, joined with just a name, and able to claim items and
/// see what they owe. Reuses the same claim sheet the authenticated
/// participant view uses, just pointed at the guest endpoints
/// (`BagilahGuestController`) via the stored [GuestSession.guestToken].
class GuestBillScreen extends ConsumerStatefulWidget {
  const GuestBillScreen({super.key, required this.billId});

  final String billId;

  @override
  ConsumerState<GuestBillScreen> createState() => _GuestBillScreenState();
}

class _GuestBillScreenState extends ConsumerState<GuestBillScreen> {
  GuestSession? _session;
  SseSubscription? _sse;
  bool _loadingSession = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session = await ref.read(guestSessionStoreProvider).load();
    if (!mounted) return;
    setState(() {
      _session = session;
      _loadingSession = false;
    });
    if (session != null) {
      _sse = SseSubscription.connect(
        '/api/v1/bagilah/guest/${session.guestToken}/events',
      );
      _sse!.events.listen((_) {
        ref.invalidate(guestBillDetailProvider(session.guestToken));
        ref.invalidate(guestBreakdownProvider(session.guestToken));
      });
    }
  }

  @override
  void dispose() {
    _sse?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingSession) {
      return const Scaffold(body: AppPageBody(child: LoadingView()));
    }

    final session = _session;
    if (session == null || session.billId != widget.billId) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bagilah')),
        body: AppPageBody(
          child: const EmptyView(
            icon: Icons.link_off,
            title: 'This guest session has expired',
            message: 'Ask for a fresh invite link to rejoin this bill.',
          ),
        ),
      );
    }

    final guestToken = session.guestToken;
    final billAsync = ref.watch(guestBillDetailProvider(guestToken));
    final itemsAsync = ref.watch(guestBillItemsProvider(guestToken));
    final participantsAsync = ref.watch(
      guestBillParticipantsProvider(guestToken),
    );
    final breakdownAsync = ref.watch(guestBreakdownProvider(guestToken));

    return Scaffold(
      appBar: AppBar(title: Text('Hi, ${session.displayName}')),
      body: AppPageBody(
        child: billAsync.when(
          data: (bill) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(guestBillDetailProvider(guestToken));
              ref.invalidate(guestBillItemsProvider(guestToken));
              ref.invalidate(guestBillParticipantsProvider(guestToken));
              ref.invalidate(guestBreakdownProvider(guestToken));
            },
            child: ListView(
              padding: AppSpacing.scrollInsets(context, floatingAction: false),
              children: [
                Text(
                  bill.merchant ?? 'Untitled bill',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  bill.receiptDate,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                breakdownAsync.maybeWhen(
                  data: (breakdown) {
                    final mine = breakdown.participants
                        .where((p) => p.participantId == session.participantId)
                        .toList();
                    if (mine.isEmpty) return const SizedBox.shrink();
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You owe',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            AmountText(
                              mine.first.finalAmount,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Items — tap to claim',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                itemsAsync.when(
                  data: (items) {
                    final participants =
                        participantsAsync.valueOrNull ?? const [];
                    return Column(
                      children: [
                        for (final item in items)
                          ReceiptItemRow(
                            name: item.name,
                            quantity: item.quantity,
                            totalPrice: item.totalPrice,
                            onTap: () => showAppBottomSheet(
                              context,
                              builder: (context) => ClaimItemSheet(
                                billId: bill.id,
                                item: item,
                                participants: participants,
                                guestToken: guestToken,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(error: e),
                ),
              ],
            ),
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e),
        ),
      ),
    );
  }
}

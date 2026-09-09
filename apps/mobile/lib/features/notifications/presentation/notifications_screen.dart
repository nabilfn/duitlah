import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_state_views.dart';
import '../application/notifications_providers.dart';
import '../domain/app_notification.dart';

/// Real, backed by the V2 Phase 3 notification architecture (spec section 24) — no longer the
/// Phase 9.5 placeholder. Push delivery itself is still not wired up (see the backend's
/// `PushNotificationProvider` Javadoc); this screen shows the in-app channel, which is real today.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _markRead(WidgetRef ref, AppNotification notification) async {
    if (notification.read) return;
    await ref.read(notificationRepositoryProvider).markRead(notification.id);
    ref.invalidate(notificationListProvider);
    ref.invalidate(unreadNotificationCountProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationListProvider),
        child: notifications.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.notifications_off_outlined, title: 'No notifications yet'),
                  ],
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final n = items[index];
                    return ListTile(
                      leading: DuitlahIcon(
                        n.read ? Icons.notifications_none : Icons.notifications,
                        color: n.read ? null : Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(n.title, style: TextStyle(fontWeight: n.read ? FontWeight.normal : FontWeight.bold)),
                      subtitle: Text(n.body),
                      onTap: () => _markRead(ref, n),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(notificationListProvider)),
        ),
      ),
    );
  }
}

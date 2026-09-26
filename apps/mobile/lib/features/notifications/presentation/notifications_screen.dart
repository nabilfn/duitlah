import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_page_body.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/notifications_providers.dart';
import '../domain/app_notification.dart';

/// In-app notifications retain their server order and existing read behavior.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _markRead(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
  ) async {
    if (notification.read) return;
    try {
      await ref.read(notificationRepositoryProvider).markRead(notification.id);
      ref.invalidate(notificationListProvider);
      ref.invalidate(unreadNotificationCountProvider);
    } catch (_) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'Couldn’t mark this as read. Tap to try again.',
        );
      }
    }
  }

  String _day(String value) {
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) return 'Updates';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationListProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(notificationListProvider),
          child: notifications.when(
            data: (items) => items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 48),
                      EmptyView(
                        icon: Icons.notifications_off_outlined,
                        title: 'You’re all caught up',
                        message: 'Bill reminders and shared-money updates will appear here.',
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppSpacing.scrollInsets(context),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final n = items[index];
                      final time = DateTime.tryParse(n.createdAt)?.toLocal();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (index == 0 ||
                              _day(items[index - 1].createdAt) !=
                                  _day(n.createdAt))
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                bottom: 12,
                              ),
                              child: Text(
                                _day(n.createdAt),
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          Semantics(
                            label: n.read ? 'Read' : 'Unread',
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              title: Text(
                                n.title,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: n.read
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Text(
                                    n.body,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    [
                                      if (!n.read) 'Unread',
                                      if (time != null)
                                        DateFormat('h:mm a').format(time),
                                    ].join(' · '),
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ],
                              ),
                              onTap: () => _markRead(context, ref, n),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(notificationListProvider),
            ),
          ),
        ),
      ),
    );
  }
}

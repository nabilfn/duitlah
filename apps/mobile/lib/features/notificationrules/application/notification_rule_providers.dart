import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/notification_rule_repository.dart';
import '../domain/notification_rule.dart';

final notificationRuleRepositoryProvider =
    Provider((ref) => NotificationRuleRepository(ref.watch(apiClientProvider)));

final notificationRuleListProvider = FutureProvider.autoDispose<List<NotificationRule>>(
  (ref) => ref.watch(notificationRuleRepositoryProvider).list(),
);

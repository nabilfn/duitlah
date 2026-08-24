import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/transaction_rule_repository.dart';
import '../domain/transaction_rule.dart';

final transactionRuleRepositoryProvider =
    Provider((ref) => TransactionRuleRepository(ref.watch(apiClientProvider)));

final transactionRuleListProvider = FutureProvider.autoDispose<List<TransactionRule>>(
  (ref) => ref.watch(transactionRuleRepositoryProvider).list(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/financial_health_repository.dart';
import '../domain/financial_health.dart';

final financialHealthRepositoryProvider =
    Provider((ref) => FinancialHealthRepository(ref.watch(apiClientProvider)));

final financialHealthProvider = FutureProvider.autoDispose<FinancialHealth>(
  (ref) => ref.watch(financialHealthRepositoryProvider).compute(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/personal_bill_repository.dart';
import '../domain/personal_bill.dart';

final personalBillRepositoryProvider =
    Provider((ref) => PersonalBillRepository(ref.watch(apiClientProvider)));

final personalBillListProvider = FutureProvider.autoDispose<List<PersonalBill>>(
  (ref) => ref.watch(personalBillRepositoryProvider).list(),
);

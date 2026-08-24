import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/personal_tax_repository.dart';
import '../domain/personal_tax.dart';

final personalTaxRepositoryProvider =
    Provider((ref) => PersonalTaxRepository(ref.watch(apiClientProvider)));

/// The Year of Assessment currently selected in the Tax Centre — defaults to the current
/// calendar year, which is usually the YA still in progress.
final selectedYearOfAssessmentProvider = StateProvider<int>((ref) => DateTime.now().year);

final personalTaxCalculationProvider = FutureProvider.autoDispose<PersonalTaxCalculation>(
  (ref) => ref.watch(personalTaxRepositoryProvider).calculate(ref.watch(selectedYearOfAssessmentProvider)),
);

final filingReadinessProvider = FutureProvider.autoDispose<FilingReadiness>(
  (ref) => ref.watch(personalTaxRepositoryProvider).filingReadiness(ref.watch(selectedYearOfAssessmentProvider)),
);

final personalIncomeListProvider = FutureProvider.autoDispose<List<PersonalIncomeRecord>>(
  (ref) => ref.watch(personalTaxRepositoryProvider).listIncome(ref.watch(selectedYearOfAssessmentProvider)),
);

final pcbListProvider = FutureProvider.autoDispose<List<PcbPayment>>(
  (ref) => ref.watch(personalTaxRepositoryProvider).listPcb(ref.watch(selectedYearOfAssessmentProvider)),
);

final zakatListProvider = FutureProvider.autoDispose<List<ZakatPayment>>(
  (ref) => ref.watch(personalTaxRepositoryProvider).listZakat(ref.watch(selectedYearOfAssessmentProvider)),
);

final taxDocumentListProvider = FutureProvider.autoDispose<List<PersonalTaxDocument>>(
  (ref) => ref.watch(personalTaxRepositoryProvider).listDocuments(ref.watch(selectedYearOfAssessmentProvider)),
);

final reliefCandidateListProvider = FutureProvider.autoDispose<List<TaxReliefCandidate>>(
  (ref) => ref.watch(personalTaxRepositoryProvider).listReliefCandidates(ref.watch(selectedYearOfAssessmentProvider)),
);

final confirmedReliefListProvider = FutureProvider.autoDispose<List<ConfirmedTaxRelief>>(
  (ref) => ref.watch(personalTaxRepositoryProvider).listConfirmedReliefs(ref.watch(selectedYearOfAssessmentProvider)),
);

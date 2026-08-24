import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/business_tax_repository.dart';
import '../domain/business_tax.dart';

/// A space plus a `from`/`to` date range — mirrors
/// `inventory_providers.dart`'s `CogsFilter` for the same "report scoped to
/// a space and a date window" shape.
typedef SstReportFilter = ({String spaceId, String from, String to});

final businessTaxRepositoryProvider =
    Provider((ref) => BusinessTaxRepository(ref.watch(apiClientProvider)));

final sstRateListProvider = FutureProvider.autoDispose.family<List<SstRate>, String>(
  (ref, spaceId) => ref.watch(businessTaxRepositoryProvider).listSstRates(spaceId),
);

final sstReportProvider = FutureProvider.autoDispose.family<SstReport, SstReportFilter>(
  (ref, filter) => ref.watch(businessTaxRepositoryProvider).getSstReport(
        filter.spaceId,
        from: filter.from,
        to: filter.to,
      ),
);

final einvoiceReadinessProvider = FutureProvider.autoDispose.family<EInvoiceReadiness, String>(
  (ref, spaceId) => ref.watch(businessTaxRepositoryProvider).getEInvoiceReadiness(spaceId),
);

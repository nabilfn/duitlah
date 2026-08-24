import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/receipt_scan_repository.dart';
import '../domain/receipt_scan.dart';

final receiptScanRepositoryProvider =
    Provider((ref) => ReceiptScanRepository(ref.watch(apiClientProvider)));

final receiptScanForReviewProvider = FutureProvider.autoDispose.family<ReceiptScan, String>(
  (ref, scanId) => ref.watch(receiptScanRepositoryProvider).getScan(scanId),
);

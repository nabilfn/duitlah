import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/cross_space_repository.dart';
import '../domain/cross_space.dart';

// ---- Repository -------------------------------------------------------------

final crossSpaceRepositoryProvider = Provider((ref) => CrossSpaceRepository(ref.watch(apiClientProvider)));

// ---- Links ------------------------------------------------------------------

/// Every link recorded for one business — feeds `cross_space_hub_screen.dart`'s
/// history section and `link_form_sheet.dart`'s "settles which advance?"
/// picker (filtered to BUSINESS_ADVANCE there).
final crossSpaceLinkListProvider = FutureProvider.autoDispose.family<List<CrossSpaceLinkResponse>, String>(
  (ref, spaceId) => ref.watch(crossSpaceRepositoryProvider).listSpaceLinks(spaceId),
);

/// Every link the current user has personally created, across every
/// business they belong to. Not wired into a screen yet — see
/// [CrossSpaceRepository.listMyLinks].
final myCrossSpaceLinkListProvider = FutureProvider.autoDispose<List<CrossSpaceLinkResponse>>(
  (ref) => ref.watch(crossSpaceRepositoryProvider).listMyLinks(),
);

// ---- Combined net worth -------------------------------------------------

final combinedNetWorthProvider = FutureProvider.autoDispose<CombinedNetWorth>(
  (ref) => ref.watch(crossSpaceRepositoryProvider).getCombinedNetWorth(),
);

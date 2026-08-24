import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/spaces_repository.dart';
import '../domain/financial_space.dart';
import '../domain/space_member.dart';

final spacesRepositoryProvider = Provider((ref) => SpacesRepository(ref.watch(apiClientProvider)));

final spaceListProvider = FutureProvider.autoDispose<List<FinancialSpace>>(
  (ref) => ref.watch(spacesRepositoryProvider).listMySpaces(),
);

final spaceMembersProvider = FutureProvider.autoDispose.family<List<SpaceMember>, String>(
  (ref, spaceId) => ref.watch(spacesRepositoryProvider).listMembers(spaceId),
);

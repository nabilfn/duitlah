import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/assistant_repository.dart';

final assistantRepositoryProvider =
    Provider((ref) => AssistantRepository(ref.watch(apiClientProvider)));

/// The Business space (if any) the Assistant screen's chat is currently scoped to -- `null`
/// means Personal (only Personal + Shared tools are available on the backend). This is
/// screen-local UI state, not an app-wide "active space" concept: the Assistant route isn't
/// nested inside any business space's navigation, so there's nothing ambient to read from (see
/// docs/ai-assistant-v2.md). Purely a UX convenience for the picker in AssistantScreen -- the
/// backend is what actually resolves and enforces which tools apply for a given `activeSpaceId`.
final assistantActiveSpaceIdProvider = StateProvider<String?>((ref) => null);

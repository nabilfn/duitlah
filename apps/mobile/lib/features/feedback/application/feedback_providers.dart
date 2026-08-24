import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/feedback_repository.dart';

final feedbackRepositoryProvider =
    Provider((ref) => FeedbackRepository(ref.watch(apiClientProvider)));

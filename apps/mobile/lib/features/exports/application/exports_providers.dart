import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/export_repository.dart';

final exportRepositoryProvider = Provider((ref) => ExportRepository(ref.watch(apiClientProvider)));

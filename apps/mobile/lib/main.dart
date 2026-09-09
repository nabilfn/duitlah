import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/api/providers.dart';
import 'core/storage/secure_storage.dart';
import 'core/theme/appearance_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = SecureStorage();
  final appearance = await loadAppearance(storage);
  runApp(ProviderScope(overrides: [
    secureStorageProvider.overrideWithValue(storage),
    initialAppearanceProvider.overrideWithValue(appearance),
  ], child: const DuitlahApp()));
}

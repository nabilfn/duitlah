import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/deep_link_service.dart';
import 'core/theme/app_theme.dart';
import 'core/api/providers.dart';

class DuitlahApp extends ConsumerStatefulWidget {
  const DuitlahApp({super.key});

  @override
  ConsumerState<DuitlahApp> createState() => _DuitlahAppState();
}

class _DuitlahAppState extends ConsumerState<DuitlahApp> {
  DeepLinkService? _deepLinks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authProvider.notifier).bootstrap();
      _deepLinks = DeepLinkService((token) {
        final router = ref.read(routerProvider);
        router.push('${AppRoutes.bagilahJoin}?token=$token');
      });
      await _deepLinks!.start();
    });
  }

  @override
  void dispose() {
    _deepLinks?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Duitlah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

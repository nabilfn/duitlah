import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/deep_link_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/appearance_provider.dart';
import 'core/theme/glass_accessibility.dart';
import 'core/api/providers.dart';
import 'features/auth/application/auth_state.dart';
import 'features/splash/presentation/app_entry_transition.dart';

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
      if (!mounted) return;
      await ref.read(authProvider.notifier).bootstrap();
      if (!mounted) return;
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
    final session = ref.watch(authProvider);
    // A resolved, signed-in session takes the short entry: returning launches
    // should not replay the full branded introduction every single time.
    final ready = session is! AuthLoading;
    final authenticated = session is AuthAuthenticated;
    return MaterialApp.router(
      title: 'Duitlah',
      debugShowCheckedModeBanner: false,
      themeAnimationDuration:
          MediaQuery.maybeOf(context)?.disableAnimations == true
          ? Duration.zero
          : const Duration(milliseconds: 180),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(appearanceProvider),
      routerConfig: router,
      builder: (context, child) =>
          GlassAccessibility(
            child: AppEntryTransition(
              ready: ready,
              authenticated: authenticated,
              child: child!,
            ),
          ),
    );
  }
}

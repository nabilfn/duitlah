import 'package:flutter/material.dart';

import '../../../core/theme/entry_palette.dart';

/// Shown only while [AuthState] is still `loading` — i.e. between app start
/// and `bootstrap()` resolving the persisted refresh cookie into either an
/// authenticated session or "no session". Without this gate, GoRouter's
/// `initialLocation` (`/home`) would render the real Home screen immediately,
/// and its data providers would fire live API calls with no access token
/// yet — surfacing a flash of raw "Authentication required" errors instead
/// of a clean loading state.
///
/// It carries no brand or progress of its own: `AppEntryTransition` paints the
/// navy environment and the `d.` signal above it, so this only has to make
/// sure nothing else shows through.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: EntryPalette.background,
    body: SizedBox.expand(),
  );
}

import 'package:flutter/material.dart';

/// Shown only while [AuthState] is still `loading` — i.e. between app start
/// and `bootstrap()` resolving the persisted refresh cookie into either an
/// authenticated session or "no session". Without this gate, GoRouter's
/// `initialLocation` (`/home`) would render the real Home screen immediately,
/// and its data providers would fire live API calls with no access token
/// yet — surfacing a flash of raw "Authentication required" errors instead
/// of a clean loading state.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Duitlah', style: theme.textTheme.displaySmall),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

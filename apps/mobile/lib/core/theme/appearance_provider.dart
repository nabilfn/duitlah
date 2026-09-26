import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/providers.dart';
import '../storage/secure_storage.dart';

const appearanceStorageKey = 'duitlah.appearance';

/// Resolved before runApp. Unknown or unavailable preferences follow the OS.
Future<ThemeMode> loadAppearance(SecureStorage storage) async {
  try {
    return switch (await storage.read(appearanceStorageKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  } catch (_) {
    return ThemeMode.system;
  }
}

final initialAppearanceProvider = Provider<ThemeMode>(
  (ref) => ThemeMode.system,
);
final appearanceProvider =
    StateNotifierProvider<AppearanceController, ThemeMode>(
      (ref) => AppearanceController(
        ref.watch(secureStorageProvider),
        ref.watch(initialAppearanceProvider),
      ),
    );

class AppearanceController extends StateNotifier<ThemeMode> {
  AppearanceController(this._storage, ThemeMode initial)
    : _saved = initial,
      super(initial);
  final SecureStorage _storage;
  ThemeMode _saved;
  Future<void> _pending = Future<void>.value();
  int _revision = 0;

  Future<void> setMode(ThemeMode mode) {
    if (state == mode) return Future<void>.value();
    final revision = ++_revision;
    state = mode;
    // Serialize rapid taps so disk and the visible choice cannot diverge.
    final operation = _pending.then((_) async {
      await _storage.write(appearanceStorageKey, mode.name);
      _saved = mode;
    });
    _pending = operation.catchError((Object _) {});
    return operation.catchError((Object error) {
      if (mounted && revision == _revision) state = _saved;
      throw error;
    });
  }
}

import 'package:delivery_flutter_app/common/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(storage: ref.watch(secureStorageProvider)),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final FlutterSecureStorage storage;

  ThemeModeNotifier({required this.storage}) : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await storage.read(key: 'theme');
    if (savedTheme != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.light,
      );
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    await storage.write(key: 'theme', value: mode.toString());
    state = mode;
  }
}

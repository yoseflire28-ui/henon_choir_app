import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

/// Manages the application's theme mode (light / dark).
/// Persists the user's preference via [SharedPreferences].
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialises the provider by loading the persisted preference.
  /// Call this once during app start-up before [runApp].
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDark = prefs.getBool(AppConstants.prefKeyDarkMode) ?? true;
    _themeMode = savedDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Toggles between dark and light mode and persists the new value.
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefKeyDarkMode, isDarkMode);
  }

  /// Sets the theme mode explicitly and persists the value.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        AppConstants.prefKeyDarkMode, mode == ThemeMode.dark);
  }
}

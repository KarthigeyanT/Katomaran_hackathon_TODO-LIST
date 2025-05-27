import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_preference';
  ThemePreference _themePreference = ThemePreference.system;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode {
    if (_themePreference == ThemePreference.light) return ThemeMode.light;
    if (_themePreference == ThemePreference.dark) return ThemeMode.dark;
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeProvider() {
    // Default to light theme
    _isDarkMode = false;
    _themePreference = ThemePreference.light;
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(_themeKey)) {
        final index = prefs.getInt(_themeKey)!;
        _themePreference = ThemePreference.values[index];
      } else {
        // If no saved preference, default to light theme
        _themePreference = ThemePreference.light;
        await prefs.setInt(_themeKey, _themePreference.index);
      }
      
      // Update dark mode based on system brightness if preference is system
      if (_themePreference == ThemePreference.system) {
        final window = WidgetsBinding.instance.window;
        _isDarkMode = window.platformBrightness == Brightness.dark;
        window.onPlatformBrightnessChanged = () {
          if (_themePreference == ThemePreference.system) {
            _isDarkMode = window.platformBrightness == Brightness.dark;
            notifyListeners();
          }
        };
      } else {
        _isDarkMode = _themePreference == ThemePreference.dark;
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      // Fallback to light theme
      _themePreference = ThemePreference.light;
      _isDarkMode = false;
      notifyListeners();
    }
  }

  Future<void> setThemePreference(ThemePreference preference) async {
    if (_themePreference == preference) return;
    
    _themePreference = preference;
    _isDarkMode = preference == ThemePreference.dark || 
                 (preference == ThemePreference.system && 
                  WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, preference.index);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  ThemePreference get themePreference => _themePreference;
}

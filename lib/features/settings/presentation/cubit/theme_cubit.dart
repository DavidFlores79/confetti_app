import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/app_logger.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'THEME_MODE';

  ThemeCubit({required this.sharedPreferences}) : super(ThemeInitial()) {
    _loadTheme();
  }

  void _loadTheme() {
    try {
      AppLogger.debug('ThemeCubit: Loading theme preference');
      final themeMode = sharedPreferences.getString(_themeKey);
      
      if (themeMode == 'dark') {
        AppLogger.info('ThemeCubit: Dark theme loaded');
        emit(ThemeDark());
      } else if (themeMode == 'light') {
        AppLogger.info('ThemeCubit: Light theme loaded');
        emit(ThemeLight());
      } else {
        // Default to system theme
        AppLogger.info('ThemeCubit: System theme loaded (default)');
        emit(ThemeSystem());
      }
    } catch (e) {
      AppLogger.error('ThemeCubit: Error loading theme', e);
      emit(ThemeSystem());
    }
  }

  Future<void> setLightTheme() async {
    try {
      AppLogger.info('ThemeCubit: Setting light theme');
      await sharedPreferences.setString(_themeKey, 'light');
      emit(ThemeLight());
    } catch (e) {
      AppLogger.error('ThemeCubit: Error setting light theme', e);
    }
  }

  Future<void> setDarkTheme() async {
    try {
      AppLogger.info('ThemeCubit: Setting dark theme');
      await sharedPreferences.setString(_themeKey, 'dark');
      emit(ThemeDark());
    } catch (e) {
      AppLogger.error('ThemeCubit: Error setting dark theme', e);
    }
  }

  Future<void> setSystemTheme() async {
    try {
      AppLogger.info('ThemeCubit: Setting system theme');
      await sharedPreferences.remove(_themeKey);
      emit(ThemeSystem());
    } catch (e) {
      AppLogger.error('ThemeCubit: Error setting system theme', e);
    }
  }

  Future<void> toggleTheme() async {
    if (state is ThemeLight) {
      await setDarkTheme();
    } else {
      await setLightTheme();
    }
  }

  bool get isDarkMode => state is ThemeDark;
  bool get isLightMode => state is ThemeLight;
  bool get isSystemMode => state is ThemeSystem;

  ThemeMode get themeMode {
    if (state is ThemeDark) return ThemeMode.dark;
    if (state is ThemeLight) return ThemeMode.light;
    return ThemeMode.system;
  }
}

import 'package:flutter/material.dart';
import 'package:not_here/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends ChangeNotifier {
  static const SYSTEM_THEME_SETTING = 'SYSTEMTHEMESETTING';

  static const THEME_SETTING = "THEMESETTING";
  static const PHONE_SETTING = 'PHONESETTING';

  AppTheme themePreference = AppTheme();

  /// Expose the selected colour themes for the app
  ThemeData get lightTheme => themePreference.lightTheme;
  ThemeData get darkTheme => themePreference.darkTheme;

  /// Information about whether to use system theme or user-set theme
  bool _useSystemTheme = false;
  bool get isUsingSystemTheme => _useSystemTheme;

  void toggleSystemTheme() {
    _useSystemTheme = !_useSystemTheme;
    _setSystemThemePref(_useSystemTheme);
  }

  void _setSystemThemePref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SYSTEM_THEME_SETTING, value);
    notifyListeners();
  }

  /// Information about user-chosen theme
  bool _isDark = false;
  bool get isDark => _isDark;
  ThemeMode get themeMode {
    if (_useSystemTheme)
      return ThemeMode.system;
    else
      return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void _setThemePref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_SETTING, value);
    notifyListeners();
  }

  /// Toggle between light mode and dark mode
  void toggleTheme() {
    _isDark = !_isDark;
    _setThemePref(_isDark);
  }

  /// Emergency phone number
  String _phone = '';
  bool get isPhoneSet => _phone.isNotEmpty;
  String get phone => _phone;
  set phone(String newPhone) => _setPhonePref(newPhone);

  void _setPhonePref(String newPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHONE_SETTING, newPhone);
    _phone = newPhone;
    notifyListeners();
  }

  /// Fetch all saved preference for the application
  Future<void> fetchSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _useSystemTheme = prefs.getBool(SYSTEM_THEME_SETTING) ?? false;
    _isDark = prefs.getBool(THEME_SETTING) ?? false;
    _phone = prefs.getString(PHONE_SETTING) ?? '';
    notifyListeners();
  }
}

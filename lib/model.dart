import 'package:flutter/material.dart';
import 'package:not_here/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends ChangeNotifier {
  static const PHONE_SETTING = 'PHONESETTING';

  AppThemePreference themePreference = AppThemePreference();

  /// Is dark theme enabled ?
  bool _isDark = false;
  bool get isDark => _isDark;

  /// Emergency phone number
  String _phone = '';
  bool get isPhoneSet => _phone.isNotEmpty;
  String get phone => _phone;
  set phone(String newPhone) => _setPhonePref(newPhone);

  /// Fetch all saved preference for the application
  Future<void> fetchSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await themePreference.getTheme();
    _phone = prefs.getString(PHONE_SETTING) ?? '';
  }

  void _setPhonePref(String newPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHONE_SETTING, newPhone);
    _phone = newPhone;
  }

  /// Expose the selected colour themes for the app
  ThemeData get currentTheme =>
      _isDark ? themePreference.darkTheme : themePreference.lightTheme;

  ThemeData get lightTheme => themePreference.lightTheme;
  ThemeData get darkTheme => themePreference.darkTheme;

  /// Toggle between light mode and dark mode
  void toggleTheme() {
    _isDark = !_isDark;
    themePreference.setThemePref(_isDark);
    notifyListeners();
  }
}

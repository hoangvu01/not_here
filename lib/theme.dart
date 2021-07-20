import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemePreference {
  static const THEME_SETTING = "THEMESETTING";

  setThemePref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_SETTING, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_SETTING) ?? false;
  }
}

class AppModel extends ChangeNotifier {
  AppThemePreference preference = AppThemePreference();
  bool _isDark = false;

  bool get isDark => _isDark;
  set isDark(bool value) {
    if (value != _isDark) {
      _isDark = value;
      preference.setThemePref(value);
      notifyListeners();
    }
  }

  void toggleTheme() {
    _isDark = !_isDark;
    preference.setThemePref(_isDark);
    notifyListeners();
  }

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  ThemeData get lightTheme => ThemeData(
        accentIconTheme: IconThemeData(
          color: const Color(0xFF457B9D),
        ),
        backgroundColor: Colors.lightBlue.shade50,
        scaffoldBackgroundColor: Colors.lightBlue.shade50,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF457B9D),
          primaryVariant: const Color(0xFFA8DADC),
          onPrimary: const Color(0xFFF1FAEE),
          secondary: const Color(0xFF1D3557),
          onBackground: Colors.white,
          onError: const Color(0xFFE63946),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontSize: 11,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey.shade600,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedIconTheme: IconThemeData(
            color: Colors.grey.shade600,
          ),
        ),
        shadowColor: Colors.blueGrey.shade100,
        dividerColor: Colors.grey,
      );

  ThemeData get darkTheme => ThemeData(
        accentIconTheme: IconThemeData(
          color: const Color(0xFF457B9D),
        ),
        backgroundColor: const Color(0xFF293241),
        scaffoldBackgroundColor: const Color(0xFF293241),
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF3D5A80),
          primaryVariant: const Color(0xFF98C1D9),
          onPrimary: const Color(0xFFE5E5E5),
          secondary: const Color(0xFFFCA311),
          onBackground: const Color(0x90E0FBFC),
          onError: const Color(0xFFEE6C4D),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline3: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyText1: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white70,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0x90E0FBFC),
          selectedIconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        shadowColor: Colors.transparent,
        dividerColor: Colors.grey,
      );
}

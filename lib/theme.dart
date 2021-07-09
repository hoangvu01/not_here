import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme() => ThemeData(
        accentIconTheme: IconThemeData(
          color: const Color(0xFF457B9D),
        ),
        backgroundColor: Color(0xFFA8DADC),
        scaffoldBackgroundColor: Color(0xFFA8DADC),
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF457B9D),
          onPrimary: const Color(0xFFF1FAEE),
          secondary: const Color(0xFF1D3557),
          onBackground: Colors.white,
          onError: const Color(0xFFE63946),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey.shade600,
        ),
        shadowColor: Colors.blueGrey.shade300,
        dividerColor: Colors.grey,
      );

  static ThemeData darkTheme() => ThemeData(
        scaffoldBackgroundColor: Colors.lightBlue.shade50,
        fontFamily: 'Montserrat',
        appBarTheme: AppBarTheme(
          color: Colors.lightBlue.shade50,
          iconTheme: IconThemeData(
            color: const Color(0x457B9D),
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: const Color(0xA8DADC),
          primaryVariant: const Color(0x457B9D),
          onPrimary: const Color(0xF1FAEE),
          secondary: const Color(0x1D3557),
          onError: const Color(0xE63946),
        ),
        iconTheme: IconThemeData(
          color: const Color(0x457B9D),
        ),
      );
}

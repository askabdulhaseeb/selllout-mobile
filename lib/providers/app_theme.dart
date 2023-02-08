import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final Brightness brightness =
          SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppThemes {
  static const Color _primary = Color(0xffBF1017);
  static const Color _secondary = Color.fromRGBO(2, 122, 190, 1);
  //
  // Dark
  //
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: _primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    scaffoldBackgroundColor: const Color(0xFF101018),
    primaryColor: _primary,
    iconTheme: const IconThemeData(color: Colors.white),
    dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 0.5),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      tileColor: Color(0xFF101018),
      horizontalTitleGap: 10,
    ),
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      secondary: _secondary,
    ),
  );

  //
  // Light
  //
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: _primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: _primary,
    iconTheme: const IconThemeData(color: Colors.black),
    dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 0.5),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      tileColor: Colors.white,
      horizontalTitleGap: 10,
    ),
    colorScheme: const ColorScheme.light(
      primary: _primary,
      secondary: _secondary,
    ),
  );
}

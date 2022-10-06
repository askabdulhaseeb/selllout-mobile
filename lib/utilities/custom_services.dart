import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomService {
  static void statusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  static SystemUiOverlayStyle systemUIOverlayStyle() {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
    );
  }

  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

import 'package:ecliniq/ecliniq_ui/lib/tokens/colors.g.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme(ThemeMode themeMode) {
    this.themeMode = themeMode;
    notifyListeners();
  }
}

extension ThemeProviderX on BuildContext {
  EcliniqColors get colors => isDarkMode ? EcliniqColors.dark : EcliniqColors.light;
  EcliniqColors get lightColors => EcliniqColors.light;
  EcliniqColors get darkColors => EcliniqColors.dark;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension ThemeModeX on ThemeMode {
  String label(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}

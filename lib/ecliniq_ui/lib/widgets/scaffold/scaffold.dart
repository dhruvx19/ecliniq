import 'package:ecliniq/ecliniq_ui/lib/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EcliniqScaffold extends StatelessWidget {
  final EcliniqAppBar? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  
  const EcliniqScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset,
    this.floatingActionButton,
    this.backgroundColor,
  });


  static const Color primaryBlue = Color(0xFF0D47A1);
  static const Color darkBlue = Color(0xFF2372EC);
  
  static const Color lightBlue = Color(0xFF1976D2);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor ?? backgroundWhite,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        body: body,
        extendBody: extendBody,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}


extension EcliniqColors on BuildContext {
  Color get primaryBlue => EcliniqScaffold.primaryBlue;
  Color get lightBlue => EcliniqScaffold.lightBlue;
  Color get backgroundWhite => EcliniqScaffold.backgroundWhite;
  Color get textDark => EcliniqScaffold.textDark;
  Color get textLight => EcliniqScaffold.textLight;
  Color get dividerColor => EcliniqScaffold.dividerColor;
}


class EcliniqTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: MaterialColor(
        0xFF0D47A1,
        <int, Color>{
          50: Color(0xFFE3F2FD),
          100: Color(0xFFBBDEFB),
          200: Color(0xFF90CAF9),
          300: Color(0xFF64B5F6),
          400: Color(0xFF42A5F5),
          500: Color(0xFF2196F3),
          600: Color(0xFF1E88E5),
          700: Color(0xFF1976D2),
          800: Color(0xFF1565C0),
          900: Color(0xFF0D47A1),
        },
      ),
      primaryColor: EcliniqScaffold.primaryBlue,
      scaffoldBackgroundColor: EcliniqScaffold.backgroundWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: EcliniqScaffold.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EcliniqScaffold.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EcliniqScaffold.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EcliniqScaffold.primaryBlue),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
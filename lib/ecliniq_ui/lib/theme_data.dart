import 'package:ecliniq/ecliniq_ui/lib/tokens/colors.g.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class AlaanThemeData {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: EcliniqTextStyles.fontFamily,
        scaffoldBackgroundColor: EcliniqColors.light.bgBaseSurface,
        textTheme: const TextTheme(
          headlineMedium: EcliniqTextStyles.headlineMedium,
          headlineSmall: EcliniqTextStyles.headlineSmall,
          bodyLarge: EcliniqTextStyles.bodyLarge,
          bodyMedium: EcliniqTextStyles.bodyMedium,
          bodySmall: EcliniqTextStyles.bodySmall,
          titleMedium: EcliniqTextStyles.titleMedium,
          titleSmall: EcliniqTextStyles.titleSmall,
          labelMedium: EcliniqTextStyles.labelMedium,
          labelSmall: EcliniqTextStyles.labelSmall,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: EcliniqTextStyles.headlineMedium,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: EcliniqColors.light.bgBaseNavBar,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: EcliniqColors.light.bgBaseOverlay,
          dragHandleColor: EcliniqColors.light.strokeNeutralExtraSubtle,
          dragHandleSize: const Size(40, 4),
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(year2023: false),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: EcliniqTextStyles.fontFamily,
        scaffoldBackgroundColor: EcliniqColors.dark.bgBaseSurface,
        textTheme: const TextTheme(
          headlineMedium: EcliniqTextStyles.headlineMedium,
          headlineSmall: EcliniqTextStyles.headlineSmall,
          bodyLarge: EcliniqTextStyles.bodyLarge,
          bodyMedium: EcliniqTextStyles.bodyMedium,
          bodySmall: EcliniqTextStyles.bodySmall,
          titleMedium: EcliniqTextStyles.titleMedium,
          titleSmall: EcliniqTextStyles.titleSmall,
          labelMedium: EcliniqTextStyles.labelMedium,
          labelSmall: EcliniqTextStyles.labelSmall,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: EcliniqTextStyles.headlineMedium,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: EcliniqColors.dark.bgBaseOverlay,
          dragHandleColor: EcliniqColors.dark.strokeNeutralExtraSubtle,
          dragHandleSize: const Size(40, 4),
        ),
      );
}

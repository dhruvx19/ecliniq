import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EcliniqTextStyles {
  EcliniqTextStyles._();

  static const fontFamily = 'Inter';

  
  static const double baseDesignWidth = 390.0;

  
  
  
  static const double minNoScaleWidth = 380.0;

  
  
  static const double minScaleFactor = 0.85;

  
  
  
  
  
  static const double scalingIntensity = 0.80;

  
  static bool enableLogging = kDebugMode;

  
  static final Map<String, bool> _loggedScreenSizes = {};

  
  static void clearLogCache() {
    _loggedScreenSizes.clear();
  }

  
  
  
  static void printScreenInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = getFontScaleFactor(context);

    
    final baseFactor = screenWidth >= minNoScaleWidth
        ? 1.0
        : (screenWidth / baseDesignWidth);
    final calculatedFactor = baseFactor * scalingIntensity;
    final uiScaleFactor = (scaleFactor * 0.92).clamp(0.88, 1.0);

    
    final exampleButtonHeight = (52.0 * uiScaleFactor).clamp(44.0, 52.0 * 1.1);
    final exampleIconSize = 24.0 * scaleFactor;
    final examplePadding = 16.0 * uiScaleFactor;
    final exampleBorderRadius = 8.0 * uiScaleFactor;

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  }

  
  
  static double getFontScaleFactor(BuildContext context, {String? styleName}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double scaleFactor;
    
    if (screenWidth >= minNoScaleWidth) {
      scaleFactor = 1.0; 
    } else {
      
      final baseFactor = screenWidth / baseDesignWidth;
      
      
      
      final calculatedFactor = baseFactor * scalingIntensity;
      
      scaleFactor = calculatedFactor < minScaleFactor
          ? minScaleFactor
          : calculatedFactor;
    }

    
    if (enableLogging) {
      final screenKey =
          '${screenWidth.toStringAsFixed(0)}x${screenHeight.toStringAsFixed(0)}';
      if (!_loggedScreenSizes.containsKey(screenKey)) {
        _loggedScreenSizes[screenKey] = true;

        
        final baseFactor = screenWidth >= minNoScaleWidth
            ? 1.0
            : (screenWidth / baseDesignWidth);
        final calculatedFactor = baseFactor * scalingIntensity;
        final uiScaleFactor = (scaleFactor * 0.92).clamp(0.88, 1.0);

        
        final exampleButtonHeight = (52.0 * uiScaleFactor).clamp(
          44.0,
          52.0 * 1.1,
        );
        final exampleIconSize =
            24.0 * scaleFactor; 
        final examplePadding = 16.0 * uiScaleFactor;
        final exampleBorderRadius = 8.0 * uiScaleFactor;

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        developer.log(
          '📱 Responsive Font Scaling - Screen Detected:\n'
          '   Screen Size: ${screenWidth.toStringAsFixed(1)}x${screenHeight.toStringAsFixed(1)}px\n'
          '   Base Width: ${baseDesignWidth}px\n'
          '   Min No-Scale: ${minNoScaleWidth}px\n'
          '   Scale Factor: ${scaleFactor.toStringAsFixed(3)} (${(scaleFactor * 100).toStringAsFixed(1)}%)\n'
          '   Device Type: ${screenWidth >= minNoScaleWidth ? "Standard/Large (no scaling)" : "Small (scaled down)"}',
          name: 'EcliniqTextStyles',
        );
      }
    }

    return scaleFactor;
  }

  
  
  
  
  
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize, {
    String? styleName,
  }) {
    final scaleFactor = getFontScaleFactor(context, styleName: styleName);
    final scaledFontSize = (baseFontSize * scaleFactor).roundToDouble();

    
    if (enableLogging && styleName != null) {
      final logKey = '${styleName}_$baseFontSize';
      if (!_loggedScreenSizes.containsKey(logKey)) {
        _loggedScreenSizes[logKey] = true;
        developer.log(
          '🔤 Font Size Calculation ($styleName):\n'
          '   Original Size: ${baseFontSize}px\n'
          '   Scaled Size: ${scaledFontSize}px\n'
          '   Difference: ${(scaledFontSize - baseFontSize).toStringAsFixed(1)}px',
          name: 'EcliniqTextStyles',
        );
      }
    }

    return scaledFontSize;
  }

  
  
  
  
  
  static TextStyle getResponsiveStyle(
    BuildContext context,
    TextStyle baseStyle, {
    String? styleName,
  }) {
    if (baseStyle.fontSize == null) {
      if (enableLogging) {
        developer.log(
          '⚠️  TextStyle has no fontSize, skipping responsive scaling${styleName != null ? " ($styleName)" : ""}',
          name: 'EcliniqTextStyles',
        );
      }
      return baseStyle;
    }

    final responsiveFontSize = getResponsiveFontSize(
      context,
      baseStyle.fontSize!,
      styleName: styleName,
    );

    return baseStyle.copyWith(fontSize: responsiveFontSize);
  }

  
  
  
  

  
  
  
  
  
  
  
  
  static double getResponsiveSize(
    BuildContext context,
    double baseSize, {
    double? minSize,
    double? maxSize,
    bool useProportionalScaling = false,
  }) {
    final scaleFactor = getFontScaleFactor(context);

    
    
    final uiScaleFactor = useProportionalScaling
        ? scaleFactor
        : (scaleFactor * 0.92).clamp(
            0.88,
            1.0,
          ); 

    double scaledSize = baseSize * uiScaleFactor;

    if (minSize != null && scaledSize < minSize) {
      scaledSize = minSize;
    }
    if (maxSize != null && scaledSize > maxSize) {
      scaledSize = maxSize;
    }

    return scaledSize.roundToDouble();
  }

  
  
  
  
  
  
  static double getResponsiveButtonHeight(
    BuildContext context, {
    double baseHeight = 52.0,
    bool debugPrint = false,
    String? debugLabel,
  }) {
    
    
    final calculatedHeight = getResponsiveSize(
      context,
      baseHeight,
      minSize: 44.0, 
      maxSize: baseHeight, 
    );
    
    if (debugPrint || enableLogging) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final label = debugLabel ?? 'Button';
      
      
      
      
      
      
      
      
      
    }
    
    return calculatedHeight;
  }
  
  
  
  
  
  
  static void printButtonHeightDebug(
    BuildContext context, {
    double baseHeight = 52.0,
    String label = 'Button',
  }) {
    getResponsiveButtonHeight(
      context,
      baseHeight: baseHeight,
      debugPrint: true,
      debugLabel: label,
    );
  }

  
  
  
  
  static double getResponsivePadding(BuildContext context, double basePadding) {
    return getResponsiveSize(context, basePadding);
  }

  
  
  
  
  static EdgeInsets getResponsiveEdgeInsetsAll(
    BuildContext context,
    double basePadding,
  ) {
    final padding = getResponsivePadding(context, basePadding);
    return EdgeInsets.all(padding);
  }

  
  
  
  
  
  static EdgeInsets getResponsiveEdgeInsetsSymmetric(
    BuildContext context, {
    required double horizontal,
    required double vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: getResponsivePadding(context, horizontal),
      vertical: getResponsivePadding(context, vertical),
    );
  }

  
  
  
  
  
  
  
  static EdgeInsets getResponsiveEdgeInsetsOnly(
    BuildContext context, {
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return EdgeInsets.only(
      left: getResponsivePadding(context, left),
      top: getResponsivePadding(context, top),
      right: getResponsivePadding(context, right),
      bottom: getResponsivePadding(context, bottom),
    );
  }

  
  
  
  
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    
    return getResponsiveSize(context, baseSize, useProportionalScaling: true);
  }

  
  
  
  
  static double getResponsiveBorderRadius(
    BuildContext context,
    double baseRadius,
  ) {
    return getResponsiveSize(context, baseRadius);
  }

  
  
  
  
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    return getResponsiveSize(context, baseSpacing);
  }

  
  
  
  
  
  static double getResponsiveWidth(
    BuildContext context,
    double baseWidth, {
    double? maxWidth,
  }) {
    return getResponsiveSize(context, baseWidth, maxSize: maxWidth);
  }

  
  
  
  
  
  
  static double getResponsiveHeight(
    BuildContext context,
    double baseHeight, {
    double? minHeight,
    double? maxHeight,
  }) {
    return getResponsiveSize(
      context,
      baseHeight,
      minSize: minHeight,
      maxSize: maxHeight,
    );
  }

  
  
  
  
  
  static Size getResponsiveSizeObject(
    BuildContext context, {
    required double baseWidth,
    required double baseHeight,
  }) {
    return Size(
      getResponsiveWidth(context, baseWidth),
      getResponsiveHeight(context, baseHeight),
    );
  }

static const TextStyle headlineXLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle titleInitial = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineLargeBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineZMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineBMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );
  static const TextStyle headlineXMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );
  static const TextStyle headlineXLMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,

    decoration: TextDecoration.none,
  );

  static const TextStyle bodyMediumProminent = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodySmallProminent = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyXSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyXSmallProminent = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle body2xSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle body2xSmallProminent = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle body2xSmallRegular = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle titleXBLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle titleXLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    letterSpacing: 0.01,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonXLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonXLargeProminent = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonMediumProminent = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelMediumProminent = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelSmallProminent = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelXSmall = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelXSmallProminent = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineXXLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineXXLargeBold = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineXXXLarge = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  
  
  
  

  
  static TextStyle responsiveHeadlineXLarge(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineXLarge,
      styleName: 'headlineXLarge',
    );
  }

  
  static TextStyle responsiveTitleInitial(BuildContext context) {
    return getResponsiveStyle(context, titleInitial, styleName: 'titleInitial');
  }

  
  static TextStyle responsiveHeadlineLarge(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineLarge,
      styleName: 'headlineLarge',
    );
  }

  
  static TextStyle responsiveHeadlineLargeBold(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineLargeBold,
      styleName: 'headlineLargeBold',
    );
  }

  
  static TextStyle responsiveHeadlineZMedium(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineZMedium,
      styleName: 'headlineZMedium',
    );
  }

  
  static TextStyle responsiveHeadlineBMedium(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineBMedium,
      styleName: 'headlineBMedium',
    );
  }

  
  static TextStyle responsiveHeadlineMedium(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineMedium,
      styleName: 'headlineMedium',
    );
  }

  
  static TextStyle responsiveHeadlineXMedium(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineXMedium,
      styleName: 'headlineXMedium',
    );
  }

  
  static TextStyle responsiveHeadlineXLMedium(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineXLMedium,
      styleName: 'headlineXLMedium',
    );
  }

  
  static TextStyle responsiveHeadlineSmall(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineSmall,
      styleName: 'headlineSmall',
    );
  }

  
  static TextStyle responsiveBodyLarge(BuildContext context) {
    return getResponsiveStyle(context, bodyLarge, styleName: 'bodyLarge');
  }

  
  static TextStyle responsiveBodyMedium(BuildContext context) {
    return getResponsiveStyle(context, bodyMedium, styleName: 'bodyMedium');
  }

  
  static TextStyle responsiveBodyMediumProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      bodyMediumProminent,
      styleName: 'bodyMediumProminent',
    );
  }

  
  static TextStyle responsiveBodySmall(BuildContext context) {
    return getResponsiveStyle(context, bodySmall, styleName: 'bodySmall');
  }

  
  static TextStyle responsiveBodySmallProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      bodySmallProminent,
      styleName: 'bodySmallProminent',
    );
  }

  
  static TextStyle responsiveBodyXSmall(BuildContext context) {
    return getResponsiveStyle(context, bodyXSmall, styleName: 'bodyXSmall');
  }

  
  static TextStyle responsiveBodyXSmallProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      bodyXSmallProminent,
      styleName: 'bodyXSmallProminent',
    );
  }

  
  static TextStyle responsiveBody2xSmall(BuildContext context) {
    return getResponsiveStyle(context, body2xSmall, styleName: 'body2xSmall');
  }

  
  static TextStyle responsiveBody2xSmallProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      body2xSmallProminent,
      styleName: 'body2xSmallProminent',
    );
  }

  
  static TextStyle responsiveBody2xSmallRegular(BuildContext context) {
    return getResponsiveStyle(
      context,
      body2xSmallRegular,
      styleName: 'body2xSmallRegular',
    );
  }

  
  static TextStyle responsiveTitleXBLarge(BuildContext context) {
    return getResponsiveStyle(context, titleXBLarge, styleName: 'titleXBLarge');
  }

  
  static TextStyle responsiveTitleXLarge(BuildContext context) {
    return getResponsiveStyle(context, titleXLarge, styleName: 'titleXLarge');
  }

  
  static TextStyle responsiveTitleMedium(BuildContext context) {
    return getResponsiveStyle(context, titleMedium, styleName: 'titleMedium');
  }

  
  static TextStyle responsiveTitleSmall(BuildContext context) {
    return getResponsiveStyle(context, titleSmall, styleName: 'titleSmall');
  }

  
  static TextStyle responsiveButtonXLarge(BuildContext context) {
    return getResponsiveStyle(context, buttonXLarge, styleName: 'buttonXLarge');
  }

  
  static TextStyle responsiveButtonXLargeProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      buttonXLargeProminent,
      styleName: 'buttonXLargeProminent',
    );
  }

  
  static TextStyle responsiveButtonLarge(BuildContext context) {
    return getResponsiveStyle(context, buttonLarge, styleName: 'buttonLarge');
  }

  
  static TextStyle responsiveButtonMedium(BuildContext context) {
    return getResponsiveStyle(context, buttonMedium, styleName: 'buttonMedium');
  }

  
  static TextStyle responsiveButtonMediumProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      buttonMediumProminent,
      styleName: 'buttonMediumProminent',
    );
  }

  
  static TextStyle responsiveButtonSmall(BuildContext context) {
    return getResponsiveStyle(context, buttonSmall, styleName: 'buttonSmall');
  }

  
  static TextStyle responsiveLabelMedium(BuildContext context) {
    return getResponsiveStyle(context, labelMedium, styleName: 'labelMedium');
  }

  
  static TextStyle responsiveLabelMediumProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      labelMediumProminent,
      styleName: 'labelMediumProminent',
    );
  }

  
  static TextStyle responsiveLabelSmall(BuildContext context) {
    return getResponsiveStyle(context, labelSmall, styleName: 'labelSmall');
  }

  
  static TextStyle responsiveLabelSmallProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      labelSmallProminent,
      styleName: 'labelSmallProminent',
    );
  }

  
  static TextStyle responsiveLabelXSmall(BuildContext context) {
    return getResponsiveStyle(context, labelXSmall, styleName: 'labelXSmall');
  }

  
  static TextStyle responsiveLabelXSmallProminent(BuildContext context) {
    return getResponsiveStyle(
      context,
      labelXSmallProminent,
      styleName: 'labelXSmallProminent',
    );
  }

  
  static TextStyle responsiveHeadlineXXLarge(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineXXLarge,
      styleName: 'headlineXXLarge',
    );
  }

  
  static TextStyle responsiveHeadlineXXLargeBold(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineXXLargeBold,
      styleName: 'headlineXXLargeBold',
    );
  }

  
  static TextStyle responsiveHeadlineXXXLarge(BuildContext context) {
    return getResponsiveStyle(
      context,
      headlineXXXLarge,
      styleName: 'headlineXXXLarge',
    );
  }
}

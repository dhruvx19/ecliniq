import 'package:flutter/material.dart';





class ScreenBreakpoints {
  static const double mobileSmall = 360;
  static const double mobileMedium = 480;
  static const double mobileLarge = 640;
  static const double tablet = 768;
  static const double desktopSmall = 1024;
  static const double desktopMedium = 1280;
  static const double desktopLarge = 1920;
}


enum DeviceType {
  mobileSmall,
  mobileMedium,
  mobileLarge,
  tablet,
  desktopSmall,
  desktopMedium,
  desktopLarge,
}


class ScreenSize {
  final Size screenSize;
  final DeviceType deviceType;
  final double width;
  final double height;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const ScreenSize({
    required this.screenSize,
    required this.deviceType,
    required this.width,
    required this.height,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  
  double getResponsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
    double? mobileSmall,
    double? mobileMedium,
    double? mobileLarge,
  }) {
    switch (deviceType) {
      case DeviceType.mobileSmall:
        return mobileSmall ?? mobile;
      case DeviceType.mobileMedium:
        return mobileMedium ?? mobile;
      case DeviceType.mobileLarge:
        return mobileLarge ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktopSmall:
      case DeviceType.desktopMedium:
      case DeviceType.desktopLarge:
        return desktop ?? tablet ?? mobile;
    }
  }

  
  int getResponsiveIntValue({
    required int mobile,
    int? tablet,
    int? desktop,
    int? mobileSmall,
    int? mobileMedium,
    int? mobileLarge,
  }) {
    return getResponsiveValue(
      mobile: mobile.toDouble(),
      tablet: tablet?.toDouble(),
      desktop: desktop?.toDouble(),
      mobileSmall: mobileSmall?.toDouble(),
      mobileMedium: mobileMedium?.toDouble(),
      mobileLarge: mobileLarge?.toDouble(),
    ).toInt();
  }

  
  EdgeInsets getResponsivePadding({
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
    EdgeInsets? mobileSmall,
    EdgeInsets? mobileMedium,
    EdgeInsets? mobileLarge,
  }) {
    switch (deviceType) {
      case DeviceType.mobileSmall:
        return mobileSmall ?? mobile;
      case DeviceType.mobileMedium:
        return mobileMedium ?? mobile;
      case DeviceType.mobileLarge:
        return mobileLarge ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktopSmall:
      case DeviceType.desktopMedium:
      case DeviceType.desktopLarge:
        return desktop ?? tablet ?? mobile;
    }
  }
}


class ResponsiveHelper {
  
  static ScreenSize getScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    DeviceType deviceType;
    bool isMobile;
    bool isTablet;
    bool isDesktop;

    if (width < ScreenBreakpoints.mobileSmall) {
      deviceType = DeviceType.mobileSmall;
      isMobile = true;
      isTablet = false;
      isDesktop = false;
    } else if (width < ScreenBreakpoints.mobileMedium) {
      deviceType = DeviceType.mobileMedium;
      isMobile = true;
      isTablet = false;
      isDesktop = false;
    } else if (width < ScreenBreakpoints.mobileLarge) {
      deviceType = DeviceType.mobileLarge;
      isMobile = true;
      isTablet = false;
      isDesktop = false;
    } else if (width < ScreenBreakpoints.tablet) {
      deviceType = DeviceType.tablet;
      isMobile = false;
      isTablet = true;
      isDesktop = false;
    } else if (width < ScreenBreakpoints.desktopSmall) {
      deviceType = DeviceType.desktopSmall;
      isMobile = false;
      isTablet = true;
      isDesktop = true;
    } else if (width < ScreenBreakpoints.desktopMedium) {
      deviceType = DeviceType.desktopMedium;
      isMobile = false;
      isTablet = true;
      isDesktop = true;
    } else {
      deviceType = DeviceType.desktopLarge;
      isMobile = false;
      isTablet = true;
      isDesktop = true;
    }

    return ScreenSize(
      screenSize: size,
      deviceType: deviceType,
      width: width,
      height: size.height,
      isMobile: isMobile,
      isTablet: isTablet,
      isDesktop: isDesktop,
    );
  }

  
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? mobileSmall,
    double? mobileMedium,
    double? mobileLarge,
  }) {
    final screenSize = getScreenSize(context);
    return screenSize.getResponsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      mobileSmall: mobileSmall,
      mobileMedium: mobileMedium,
      mobileLarge: mobileLarge,
    );
  }

  
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
    EdgeInsets? mobileSmall,
    EdgeInsets? mobileMedium,
    EdgeInsets? mobileLarge,
  }) {
    final screenSize = getScreenSize(context);
    return screenSize.getResponsivePadding(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      mobileSmall: mobileSmall,
      mobileMedium: mobileMedium,
      mobileLarge: mobileLarge,
    );
  }

  
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  
  static double getResponsiveIconSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  
  static double getResponsiveSpacing(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}


class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(ScreenSize screenSize) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveHelper.getScreenSize(context);
    return builder(screenSize);
  }
}


class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveHelper.getScreenSize(context);

    if (screenSize.isDesktop && desktop != null) {
      return desktop!;
    } else if (screenSize.isTablet && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}


class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveValue(
      context,
      mobile: mobileFontSize ?? style?.fontSize ?? 16,
      tablet: tabletFontSize,
      desktop: desktopFontSize,
    );

    return Text(
      text,
      style: style?.copyWith(fontSize: fontSize) ?? TextStyle(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}


class ResponsiveSizedBox extends StatelessWidget {
  final double? mobileWidth;
  final double? mobileHeight;
  final double? tabletWidth;
  final double? tabletHeight;
  final double? desktopWidth;
  final double? desktopHeight;

  const ResponsiveSizedBox({
    super.key,
    this.mobileWidth,
    this.mobileHeight,
    this.tabletWidth,
    this.tabletHeight,
    this.desktopWidth,
    this.desktopHeight,
  });

  @override
  Widget build(BuildContext context) {
    final width = ResponsiveHelper.getResponsiveValue(
      context,
      mobile: mobileWidth ?? 0,
      tablet: tabletWidth,
      desktop: desktopWidth,
    );

    final height = ResponsiveHelper.getResponsiveValue(
      context,
      mobile: mobileHeight ?? 0,
      tablet: tabletHeight,
      desktop: desktopHeight,
    );

    return SizedBox(width: width, height: height);
  }
}


class ResponsivePadding extends StatelessWidget {
  final EdgeInsets mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;
  final EdgeInsets? mobileSmall;
  final EdgeInsets? mobileMedium;
  final EdgeInsets? mobileLarge;
  final Widget child;

  const ResponsivePadding({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileSmall,
    this.mobileMedium,
    this.mobileLarge,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      mobileSmall: mobileSmall,
      mobileMedium: mobileMedium,
      mobileLarge: mobileLarge,
    );

    return Padding(
      padding: padding,
      child: child,
    );
  }
}


class ResponsiveSliverPadding extends StatelessWidget {
  final EdgeInsets mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;
  final Widget child;

  const ResponsiveSliverPadding({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );

    return SliverPadding(
      padding: padding,
      sliver: child,
    );
  }
}


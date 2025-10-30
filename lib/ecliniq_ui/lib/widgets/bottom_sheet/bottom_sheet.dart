
import 'package:flutter/material.dart';

class EcliniqBottomSheet with WidgetsBindingObserver {
  static BuildContext? _bottomSheetContext;
  static bool closeWhenAppPaused = false;

  const EcliniqBottomSheet();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? horizontalPadding = 20,
    double? verticalPadding = 0,
    Color? barrierColor,
    Color? backgroundColor,
    VoidCallback? onClosing,
    bool? closeWhenAppPaused,
    bool? isDismissible = true,
  }) {
    const bottomSheet = EcliniqBottomSheet();
    if (closeWhenAppPaused != null) {
      EcliniqBottomSheet.closeWhenAppPaused = closeWhenAppPaused;
    }
    WidgetsBinding.instance.addObserver(bottomSheet);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: barrierColor,
       backgroundColor: Colors.white,
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
        reverseDuration: Duration(milliseconds: 300),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      isDismissible: isDismissible ?? true,
      enableDrag: isDismissible ?? true,
      builder: (bottomSheetContext) {
        _bottomSheetContext = bottomSheetContext;
        return PopScope(
          canPop: isDismissible ?? true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDismissible ?? true)
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 14),
                ),
              Flexible(child: SafeArea(child: child)),
            ],
          ),
        );
      },
    ).whenComplete(() {
      WidgetsBinding.instance.removeObserver(bottomSheet);
      _bottomSheetContext = null;
      onClosing?.call();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        _bottomSheetContext != null &&
        closeWhenAppPaused) {
      Navigator.of(_bottomSheetContext!).pop();
    }
  }
}

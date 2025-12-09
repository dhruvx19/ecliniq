import 'package:flutter/material.dart';

/// Utility class for showing snackbars with consistent behavior across the app.
/// All snackbars created through this utility are dismissible by swiping.
class SnackBarHelper {
  /// Shows a simple snackbar with the given message.
  /// The snackbar is dismissible by swiping horizontally.
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Shows an error snackbar with red background.
  /// The snackbar is dismissible by swiping horizontally.
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Shows a success snackbar with green background.
  /// The snackbar is dismissible by swiping horizontally.
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Shows a warning snackbar with orange background.
  /// The snackbar is dismissible by swiping horizontally.
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}

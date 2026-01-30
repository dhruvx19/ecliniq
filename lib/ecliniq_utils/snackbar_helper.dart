import 'package:flutter/material.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/error_snackbar.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/success_snackbar.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/action_snackbar.dart';



class SnackBarHelper {
  
  
  
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    
    if (action != null) {
      CustomActionSnackBar.show(
        context: context,
        title: 'Notification',
        subtitle: message,
        duration: duration,
      );
    } else {
      CustomSuccessSnackBar.show(
        context: context,
        title: 'Notification',
        subtitle: message,
        duration: duration,
      );
    }
  }

  
  
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    CustomErrorSnackBar.show(
      context: context,
      title: 'Error',
      subtitle: message,
      duration: duration,
    );
  }

  
  
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomSuccessSnackBar.show(
      context: context,
      title: 'Success',
      subtitle: message,
      duration: duration,
    );
  }

  
  
  static void showActionSnackBar(
    BuildContext context,
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomActionSnackBar.show(
      context: context,
      title: title,
      subtitle: message,
      duration: duration,
    );
  }

  
  
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomActionSnackBar.show(
      context: context,
      title: 'Warning',
      subtitle: message,
      duration: duration,
    );
  }
}

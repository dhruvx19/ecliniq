import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/health_files.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/home_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/my_visits.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Helper class for managing main navigation between bottom tab screens
/// with direction-based transitions
class NavigationHelper {
  /// Navigate to a specific tab index with appropriate transition
  /// 
  /// Transitions:
  /// - Left to right (slideRight) when moving forward (lower to higher index)
  /// - Right to left (slideLeft) when moving backward (higher to lower index)
  static Future<void> navigateToTab(
    BuildContext context,
    int newIndex,
    int currentIndex,
  ) async {
    // Don't navigate if already on the target tab
    if (newIndex == currentIndex) {
      return;
    }

    // Determine transition direction based on index comparison
    final PageTransitionType transition = newIndex > currentIndex
        ? PageTransitionType.leftToRight
        : PageTransitionType.rightToLeft;

    Widget targetPage;

    switch (newIndex) {
      case 0:
        targetPage = const HomeScreen();
        break;
      case 1:
        targetPage = const MyVisits();
        break;
      case 2:
        targetPage = const HealthFiles();
        break;
      case 3:
        targetPage = const ProfilePage();
        break;
      default:
        targetPage = const HomeScreen();
    }

    // Use pushReplacement to avoid stacking pages in navigation stack
    // This maintains a clean navigation history for tab switching
    // Using optimized 250ms duration for smooth transitions
    await EcliniqRouter.pushReplacement(
      targetPage,
      transition: transition,
      duration: const Duration(milliseconds: 250),
    );
  }
}


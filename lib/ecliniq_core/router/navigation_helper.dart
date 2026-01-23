import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/health_files.dart';
import 'package:ecliniq/ecliniq_icons/assets/home/home_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/my_visits.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Helper class for managing main navigation between bottom tab screens
/// with direction-based transitions
class NavigationHelper {
  /// Navigate to a specific tab index with direction-based transitions
  /// 
  /// Transitions are direction-aware: forward navigation (higher index) slides left to right,
  /// backward navigation (lower index) slides right to left for smooth, intuitive navigation
  static Future<void> navigateToTab(
    BuildContext context,
    int newIndex,
    int currentIndex,
  ) async {
    // Don't navigate if already on the target tab
    if (newIndex == currentIndex) {
      return;
    }

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
    // Determine transition direction based on tab index
    // When moving forward (newIndex > currentIndex): slide left to right (rightToLeft transition)
    // When moving backward (newIndex < currentIndex): slide right to left (leftToRight transition)
    final transitionType = newIndex > currentIndex
        ? PageTransitionType.rightToLeft  // Forward: new tab slides in from right
        : PageTransitionType.leftToRight; // Backward: new tab slides in from left

    await EcliniqRouter.pushReplacement(
      targetPage,
      transition: transitionType,
      duration: const Duration(milliseconds: 350), // Smooth transition duration
    );
  }
}


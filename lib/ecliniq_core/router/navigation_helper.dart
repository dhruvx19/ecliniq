import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/health_files.dart';
import 'package:ecliniq/ecliniq_icons/assets/home/home_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/my_visits.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';



class NavigationHelper {
  
  
  
  
  static Future<void> navigateToTab(
    BuildContext context,
    int newIndex,
    int currentIndex,
  ) async {
    
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

    
    
    
    
    
    final transitionType = newIndex > currentIndex
        ? PageTransitionType.rightToLeft  
        : PageTransitionType.leftToRight; 

    await EcliniqRouter.pushReplacement(
      targetPage,
      transition: transitionType,
      duration: const Duration(milliseconds: 350), 
    );
  }
}


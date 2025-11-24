import 'package:ecliniq/ecliniq_core/auth/session_service.dart';
import 'package:ecliniq/ecliniq_core/auth/secure_storage.dart';

/// Manages authentication flow and determines which screen to show
class AuthFlowManager {
  /// Determine the initial screen based on user state
  /// Matches backend logic: redirectTo 'home' if patient profile exists, 'profile_setup' if not
  /// Returns: 'onboarding', 'login', or 'home'
  /// 
  /// Flow:
  /// 1. Check if user has valid session (token exists and not expired)
  /// 2. If valid session → Check onboarding status → Go to home or onboarding
  /// 3. If no valid session → Check saved flow state to resume from where user left off
  /// 4. If no saved flow state → Check if MPIN exists → Go to login (if MPIN exists) or onboarding (if new user)
  static Future<String> getInitialRoute() async {
    try {
      // Optimize: Run checks in parallel where possible
      // Step 1: Check if user has valid session (has valid token AND token is not expired)
      final hasValidSession = await SessionService.hasValidSession();
      
      if (hasValidSession) {
        // User has valid token - check if onboarding is complete (patient profile exists)
        // This matches backend logic: redirectTo 'home' if patient profile exists
        final isOnboardingComplete = await SessionService.isOnboardingComplete();
        
        if (isOnboardingComplete) {
          // Patient profile exists - go to home (matches backend redirectTo: 'home')
          // Clear any saved flow state since user is fully authenticated
          SessionService.clearFlowState(); // Don't await - fire and forget
          return 'home';
        } else {
          // Patient profile doesn't exist - show onboarding (matches backend redirectTo: 'profile_setup')
          return 'onboarding';
        }
      }
      
      // Step 2: NO valid session - check if there's a saved flow state to resume
      // Optimize: Run checks in parallel
      final results = await Future.wait([
        SessionService.getFlowState(),
        SessionService.isFirstLaunch(),
        SecureStorageService.hasMPIN(),
      ]);
      
      final savedFlowState = results[0] as String?;
      final isFirstLaunch = results[1] as bool;
      final hasMPIN = results[2] as bool;
      
      // This allows users to resume from where they left off if they exited the app mid-flow
      if (savedFlowState != null && savedFlowState.isNotEmpty) {
        // Valid flow states that can be resumed: 'phone_input', 'otp', 'mpin_setup', 'biometric_setup', 'onboarding'
        // Don't resume 'login' or 'home' as those require authentication
        if (['phone_input', 'otp', 'mpin_setup', 'biometric_setup', 'onboarding'].contains(savedFlowState)) {
          // Map flow states to routes
          if (savedFlowState == 'phone_input' || savedFlowState == 'otp') {
            return 'onboarding'; // Start from welcome/phone input
          } else if (savedFlowState == 'mpin_setup' || savedFlowState == 'biometric_setup') {
            return 'onboarding'; // Start from welcome/phone input (need to re-authenticate)
          } else if (savedFlowState == 'onboarding') {
            return 'onboarding'; // Resume onboarding
          }
        }
      }
      
      // Step 3: Check if this is first app launch (new install)
      // If first launch, always show welcome screen and clear any stale data
      // This handles the case where app is deleted and reinstalled
      // Note: On iOS, Keychain data can persist even after app deletion
      
      if (isFirstLaunch) {
        // First launch - clear any stale MPIN/biometric data that might persist
        // (e.g., from Keychain on iOS after app deletion)
        // Don't await - fire and forget for faster startup
        Future.wait([
          SecureStorageService.deleteMPIN(),
          SecureStorageService.setBiometricEnabled(false),
          SessionService.clearFlowState(),
        ]);
        
        // Always show welcome screen for first launch (new user flow)
        return 'onboarding';
      }
      
      // Step 4: NOT first launch - check if user has MPIN set up
      // If MPIN exists, user is a returning user - show login page
      // If no MPIN, user is new - show welcome/onboarding screen
      
      if (hasMPIN) {
        // Returning user with MPIN - show login page
        return 'login';
      } else {
        // User without MPIN - show welcome/onboarding screen
        return 'onboarding';
      }
    } catch (e) {
      // On error, default to onboarding
      return 'onboarding';
    }
  }

  /// Check if user is registered
  /// NOTE: MPIN check removed - always returns false
  static Future<bool> isUserRegistered() async {
    // No-op: UI only, always returns false
    return false;
  }

  /// Check if user is authenticated (has valid session)
  static Future<bool> isUserAuthenticated() async {
    try {
      return await SessionService.hasValidSession();
    } catch (e) {
      return false;
    }
  }

  /// Check if onboarding is complete
  static Future<bool> isOnboardingComplete() async {
    try {
      return await SessionService.isOnboardingComplete();
    } catch (e) {
      return false;
    }
  }
}


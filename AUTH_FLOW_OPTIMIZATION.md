# Authentication Flow Optimization

## Overview
This document explains the optimized authentication flow that handles:
1. **API-driven navigation** based on `redirectTo` from OTP verification
2. **Flow state persistence** for resuming from where user left off
3. **Smart routing** that skips unnecessary steps (e.g., MPIN setup for new users)

## Flow Diagrams

### Standard Flow (All Users)
```
Phone Input → OTP Verification → MPIN Setup → User Details → Home
```

### Returning User Flow (MPIN already exists)
```
Phone Input → OTP Verification → Login (MPIN exists, just re-authenticate)
```

## Key Changes

### 1. AuthProvider Updates
- **Added `redirectTo` property**: Exposes the `redirectTo` value from OTP verification API response
- **Stores redirectTo**: Saves `redirectTo` in memory for navigation decisions

### 2. OTP Screen Updates
- **Standard flow**: Always follows OTP → MPIN → User Details flow
- **Flow state persistence**: Saves current flow state using `SessionService.saveFlowState()`
- **Routing logic**:
  - If MPIN not set: OTP → MPIN Setup
  - If MPIN exists: OTP → Login (for re-authentication)

### 3. UserDetails (Profile Setup) Updates
- **Navigates to Home after completion**: After profile is saved, goes directly to Home
- **Flow**: User Details → Home

### 4. MPIN Setup Updates
- **Always navigates to User Details**: After MPIN is set, goes to User Details screen
- **Flow**: MPIN Setup → User Details → Home

### 5. Flow State Persistence
- **SessionService methods**:
  - `saveFlowState(String state)`: Saves current flow state
  - `getFlowState()`: Retrieves saved flow state
  - `clearFlowState()`: Clears flow state when flow is complete
- **Flow states**:
  - `"phone_input"`: User is on phone input screen
  - `"otp"`: User is on OTP verification screen
  - `"profile_setup"`: User is on profile setup screen
  - `"mpin_setup"`: User is on MPIN setup screen
  - `"mpin_reset"`: User is resetting MPIN

## App State Persistence (Resume from App Close)

### How It Works
1. **Save state on each step**: Flow state is saved when user progresses
2. **Resume on app restart**: `AuthFlowManager.getInitialRoute()` checks saved flow state
3. **Smart resume logic**:
   - If user has valid session: Navigate based on onboarding status
   - If no valid session but flow state exists: Resume from saved state
   - If no flow state: Start from beginning

### Example Scenarios

#### Scenario 1: User closes app during OTP verification
1. User enters phone number → OTP sent
2. User closes app (flow state: `"otp"`)
3. User reopens app → Resumes at OTP screen

#### Scenario 2: User closes app during profile setup
1. User completes OTP → Profile setup screen
2. User closes app (flow state: `"profile_setup"`)
3. User reopens app → Resumes at profile setup screen

#### Scenario 3: User closes app after MPIN setup
1. User completes MPIN → Navigating to next screen
2. User closes app (flow state: `"mpin_setup"`)
3. User reopens app → Checks onboarding status → Navigates accordingly

## Backend Recommendations

### Current API Response Structure
```json
{
  "success": true,
  "message": "User verified successfully",
  "data": {
    "token": "eyJhbGci...",
    "userStatus": "new",
    "message": "User verified successfully, please complete profile",
    "redirectTo": "profile_setup"
  }
}
```

### Recommended Backend Changes

#### 1. Consistent `redirectTo` Values
Ensure `redirectTo` is always present and uses these values:
- `"profile_setup"`: User needs to complete profile (new user or incomplete profile)
- `"home"`: User has completed onboarding (existing user with complete profile)
- `"mpin_setup"`: User needs to set MPIN (optional, can be handled client-side)

#### 2. Add `hasMPIN` Flag (Optional)
Consider adding a `hasMPIN` boolean to the response:
```json
{
  "data": {
    "token": "...",
    "redirectTo": "profile_setup",
    "hasMPIN": false,
    "hasProfile": false
  }
}
```

#### 3. Token Expiration Handling
- Ensure tokens have appropriate expiration times
- Consider refresh tokens for better UX
- Return clear error codes when token expires

#### 4. Profile Completion Status
- Return `hasProfile` or `profileComplete` flag in OTP verification response
- This helps client-side routing decisions

### Backend API Endpoints

#### POST `/api/auth/verify-user`
**Request:**
```json
{
  "challengeId": "uuid",
  "phone": "+911234567890",
  "otp": "123456"
}
```

**Response (New User):**
```json
{
  "success": true,
  "message": "User verified successfully",
  "data": {
    "token": "jwt_token",
    "userStatus": "new",
    "redirectTo": "profile_setup",
    "hasMPIN": false,
    "hasProfile": false
  }
}
```

**Response (Existing User):**
```json
{
  "success": true,
  "message": "User verified successfully",
  "data": {
    "token": "jwt_token",
    "userStatus": "existing",
    "redirectTo": "home",
    "hasMPIN": true,
    "hasProfile": true
  }
}
```

## Testing Checklist

### New User Flow
- [ ] Phone input → OTP → Profile setup → MPIN → Home
- [ ] App close during OTP → Resume at OTP
- [ ] App close during profile setup → Resume at profile setup
- [ ] App close during MPIN setup → Resume appropriately

### Existing User Flow
- [ ] Phone input → OTP → Login (if MPIN exists)
- [ ] Phone input → OTP → MPIN setup (if MPIN doesn't exist) → Home
- [ ] App close during OTP → Resume at OTP

### Edge Cases
- [ ] Token expiration during flow
- [ ] Network error during OTP verification
- [ ] Invalid OTP handling
- [ ] Back button navigation
- [ ] Deep link handling

## Benefits

1. **Better UX**: Users skip unnecessary steps (MPIN setup before profile)
2. **State Persistence**: Users can resume from where they left off
3. **API-Driven**: Navigation decisions based on backend response
4. **Flexible**: Easy to add new flow states or modify existing ones
5. **Robust**: Handles app restarts gracefully

## Migration Notes

### For Existing Users
- Existing users with MPIN will continue to work as before
- Flow state persistence is backward compatible
- No data migration required

### For New Users
- New users will follow the optimized flow
- Profile setup happens before MPIN setup
- Better onboarding experience

## Future Enhancements

1. **Biometric Setup**: Add flow state for biometric setup
2. **Deep Linking**: Handle deep links to specific flow states
3. **Analytics**: Track flow completion rates
4. **A/B Testing**: Test different flow orders
5. **Offline Support**: Cache flow state for offline scenarios


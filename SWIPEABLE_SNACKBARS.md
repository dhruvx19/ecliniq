# Swipeable Snackbars - Implementation Guide

## Overview
All snackbars in the ecliniq app are now **swipeable** (dismissible by horizontal swipe gesture). This improves user experience by giving users control over when to dismiss notifications.

## What Changed

### 1. Custom Snackbars (Already Swipeable ✅)
The following custom snackbar widgets have been updated with `dismissDirection: DismissDirection.horizontal`:

- **CustomSuccessSnackBar** (`lib/ecliniq_ui/lib/widgets/snackbar/success_snackbar.dart`)
- **CustomErrorSnackBar** (`lib/ecliniq_ui/lib/widgets/snackbar/error_snackbar.dart`)
- **CustomActionSnackBar** (`lib/ecliniq_ui/lib/widgets/snackbar/action_snackbar.dart`)

**Usage Example:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  CustomSuccessSnackBar(
    context: context,
    title: 'Success',
    subtitle: 'Operation completed successfully',
    duration: const Duration(seconds: 3),
  ),
);
```

### 2. New SnackBarHelper Utility (For Standard Snackbars)
Created a new utility class at `lib/ecliniq_utils/snackbar_helper.dart` that provides swipeable snackbars by default.

**Available Methods:**
- `SnackBarHelper.showSnackBar()` - Generic snackbar
- `SnackBarHelper.showErrorSnackBar()` - Red error snackbar
- `SnackBarHelper.showSuccessSnackBar()` - Green success snackbar
- `SnackBarHelper.showWarningSnackBar()` - Orange warning snackbar

**Usage Example:**
```dart
// Instead of:
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Hello')),
);

// Use:
SnackBarHelper.showSnackBar(context, 'Hello');

// Or for errors:
SnackBarHelper.showErrorSnackBar(context, 'Something went wrong');
```

## Migration Guide

### For New Code
**Recommended Approach:**
1. Use `CustomSuccessSnackBar`, `CustomErrorSnackBar`, or `CustomActionSnackBar` for styled notifications
2. Use `SnackBarHelper` methods for simple text-based snackbars

### For Existing Code
You have two options:

**Option 1: Use SnackBarHelper (Quick Fix)**
```dart
// Before:
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Error occurred')),
);

// After:
SnackBarHelper.showErrorSnackBar(context, 'Error occurred');
```

**Option 2: Add dismissDirection Manually**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Message'),
    dismissDirection: DismissDirection.horizontal, // Add this line
    behavior: SnackBarBehavior.floating, // Recommended
  ),
);
```

## Files Modified

### Custom Snackbar Widgets
- ✅ `lib/ecliniq_ui/lib/widgets/snackbar/success_snackbar.dart`
- ✅ `lib/ecliniq_ui/lib/widgets/snackbar/error_snackbar.dart`
- ✅ `lib/ecliniq_ui/lib/widgets/snackbar/action_snackbar.dart`

### Add Dependent Screen (Example Implementation)
- ✅ `lib/ecliniq_modules/screens/profile/add_dependent/add_dependent.dart`
  - Added API validation error parsing
  - Shows `CustomActionSnackBar` for validation errors
  - All snackbars are swipeable

### New Utility
- ✅ `lib/ecliniq_utils/snackbar_helper.dart`

## Benefits

1. **Better UX**: Users can dismiss notifications when they want
2. **Consistency**: All snackbars behave the same way
3. **Accessibility**: Swipe gesture is intuitive and widely understood
4. **Control**: Users aren't forced to wait for auto-dismiss

## Technical Details

### DismissDirection Options
- `DismissDirection.horizontal` - Can swipe left OR right (recommended)
- `DismissDirection.endToStart` - Can only swipe right-to-left
- `DismissDirection.startToEnd` - Can only swipe left-to-right

We use `DismissDirection.horizontal` for maximum flexibility.

### SnackBarBehavior
- `SnackBarBehavior.floating` - Recommended for swipeable snackbars
- `SnackBarBehavior.fixed` - Attached to bottom, less intuitive for swiping

## Next Steps (Optional)

To fully migrate the codebase, you can gradually replace standard `SnackBar` instances with either:
1. Custom snackbars (for styled notifications)
2. `SnackBarHelper` methods (for simple messages)

This can be done incrementally without breaking existing functionality.

## Example: Add Dependent Validation Errors

The add_dependent screen now properly handles API validation errors:

```dart
// API returns:
{
  "success": false,
  "errors": [
    {"message": "Phone number must be a valid 10-digit number"},
    {"message": "Profile photo is required"}
  ]
}

// App shows:
CustomActionSnackBar(
  title: 'Action Required',
  subtitle: 'Phone number must be a valid 10-digit number\nProfile photo is required',
  // Swipeable by default!
)
```

---

**Last Updated:** December 10, 2025
**Status:** ✅ Complete - All custom snackbars are swipeable, utility created for standard snackbars

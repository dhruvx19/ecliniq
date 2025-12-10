# Snackbar Visibility in Bottom Sheets - Implementation Guide

## Problem
When showing snackbars inside a bottom sheet (like `add_dependent`), the snackbar would appear behind the bottom sheet in the parent scaffold, making it invisible to users.

## Solution
Wrap the bottom sheet content with a `Scaffold` widget. This creates a new scaffold context where snackbars will appear on top of the bottom sheet content.

## Implementation

### Before (Snackbar Hidden Behind Bottom Sheet)
```dart
@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => AddDependentProvider(),
    child: Consumer<AddDependentProvider>(
      builder: (context, provider, child) {
        return Container(  // ❌ No Scaffold - snackbar appears in parent
          decoration: BoxDecoration(...),
          child: Column(...),
        );
      },
    ),
  );
}
```

### After (Snackbar Visible Above Bottom Sheet)
```dart
@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => AddDependentProvider(),
    child: Consumer<AddDependentProvider>(
      builder: (context, provider, child) {
        return Scaffold(  // ✅ Scaffold wrapper
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(...),
            child: Column(...),
          ),
        );
      },
    ),
  );
}
```

## Key Points

### 1. Scaffold Wrapper
- **Purpose**: Creates a new scaffold context for the bottom sheet
- **backgroundColor**: Set to `Colors.transparent` to maintain bottom sheet appearance
- **body**: Contains the original bottom sheet content

### 2. Snackbar Context
When you call `ScaffoldMessenger.of(context)` inside the bottom sheet:
- **Without Scaffold**: Uses parent scaffold (behind bottom sheet)
- **With Scaffold**: Uses bottom sheet's scaffold (on top of content)

### 3. Positioning
The custom snackbars are already positioned at the top of the screen:
```dart
margin: EdgeInsets.only(
  top: safeAreaTop + 7,
  left: 16,
  right: 16,
  bottom: screenHeight * 0.8, // Pushes snackbar to top
),
```

This ensures they appear:
- Above the bottom sheet content
- Below the status bar
- Visible to the user

## Files Modified

### Bottom Sheet Implementation
- ✅ `lib/ecliniq_modules/screens/profile/add_dependent/add_dependent.dart`
  - Added `Scaffold` wrapper around bottom sheet content
  - Set `backgroundColor: Colors.transparent`
  - Wrapped existing `Container` in `body` parameter

## How It Works

### Visual Hierarchy
```
┌─────────────────────────────────┐
│  Status Bar                      │
├─────────────────────────────────┤
│  🔔 Snackbar (visible here!)    │ ← Appears in bottom sheet's Scaffold
├─────────────────────────────────┤
│                                 │
│  Bottom Sheet Content           │
│  (Add Dependent Form)           │
│                                 │
│  [Save Button]                  │
└─────────────────────────────────┘
```

### Without Scaffold Wrapper
```
┌─────────────────────────────────┐
│  Status Bar                      │
│  🔔 Snackbar (hidden!)          │ ← Behind bottom sheet
├─────────────────────────────────┤
│                                 │
│  Bottom Sheet Content           │
│  (Covers the snackbar)          │
│                                 │
│  [Save Button]                  │
└─────────────────────────────────┘
```

## Usage Example

### Showing Validation Errors
```dart
Future<void> _saveDependent(AddDependentProvider provider) async {
  if (!provider.isFormValid) {
    // This snackbar will appear ABOVE the bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      CustomErrorSnackBar(
        context: context,
        title: 'Validation Failed',
        subtitle: provider.getValidationErrorMessage(),
      ),
    );
    return;
  }
  // ... rest of save logic
}
```

### API Validation Errors
```dart
// When API returns validation errors
if (apiErrors.isNotEmpty) {
  // This action snackbar appears ABOVE the bottom sheet
  ScaffoldMessenger.of(context).showSnackBar(
    CustomActionSnackBar(
      context: context,
      title: 'Action Required',
      subtitle: apiErrors.join('\n'),
    ),
  );
}
```

## Best Practices

### 1. Always Use Scaffold for Bottom Sheets with Snackbars
If your bottom sheet needs to show snackbars, wrap it with a Scaffold.

### 2. Set Transparent Background
```dart
Scaffold(
  backgroundColor: Colors.transparent, // Important!
  body: YourBottomSheetContent(),
)
```

### 3. Keep Existing Styling
The Scaffold wrapper doesn't affect the bottom sheet's appearance because:
- Background is transparent
- Content is wrapped in the original Container with decoration

### 4. Test Visibility
Always test that snackbars are visible when:
- Bottom sheet is fully expanded
- Bottom sheet is partially scrolled
- Keyboard is visible (if applicable)

## Benefits

✅ **Improved UX**: Users can see validation errors immediately  
✅ **Better Feedback**: Success/error messages are visible during form submission  
✅ **Consistent Behavior**: Snackbars work the same way in bottom sheets as in regular screens  
✅ **No Layout Changes**: Transparent scaffold doesn't affect bottom sheet appearance  

## Applies To

This pattern should be used for any bottom sheet that needs to show snackbars:
- ✅ Add Dependent Bottom Sheet
- 📋 Add Profile Photo Bottom Sheet (if it shows snackbars)
- 📋 Any custom bottom sheet with form validation
- 📋 Any bottom sheet with async operations that need user feedback

---

**Last Updated:** December 10, 2025  
**Status:** ✅ Complete - Snackbars now visible in bottom sheets

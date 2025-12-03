# PhonePe Payment Flow - Simplified for Testing

## How It Works Now

### User Flow
1. **User clicks "Confirm Appointment"** → Backend creates payment and returns `token` (base64 request)
2. **App navigates to Payment Screen** → Shows "Opening PhonePe..." message
3. **PhonePe SDK automatically opens** → PhonePe app (or simulator in sandbox)
4. **PhonePe shows all payment options**:
   - All installed UPI apps (GPay, Paytm, BHIM, etc.)
   - UPI ID entry field
   - Card payment
   - Net Banking
   - Wallet
5. **User selects payment method** → Completes payment in PhonePe
6. **PhonePe returns to app** → Via deep link (`ecliniq://`)
7. **App verifies payment** → Polls backend for status
8. **Shows success screen** → Appointment confirmed

## Key Points

### ✅ PhonePe SDK Handles Everything
- **No custom UPI selector needed** - PhonePe SDK shows all options automatically
- **Works with PhonePe Simulator** - For sandbox testing
- **Works with real PhonePe app** - For production

### 🔧 Current Implementation

**PaymentProcessingScreen** (`payment_processing_screen.dart`):
```dart
// Simplified flow - directly calls PhonePe SDK
final result = await _phonePeService.startPayment(
  request: widget.token,      // base64 from backend
  appSchema: widget.appSchema, // 'ecliniq'
);

// PhonePe SDK automatically:
// 1. Opens PhonePe app/simulator
// 2. Shows all payment methods
// 3. User pays
// 4. Returns via deep link
```

**PhonePeService** (`phonepe_service.dart`):
```dart
// Calls PhonePe SDK directly
final response = await PhonePePaymentSdk.startTransaction(
  request,   // base64 token from backend
  appSchema, // 'ecliniq' - your URL scheme
);
```

### 📱 Testing with PhonePe Simulator

1. **Install PhonePe Simulator** (sandbox mode)
   - Package: `com.phonepe.simulator`
   - Available from PhonePe developer portal

2. **Set sandbox credentials**:
   ```dart
   const merchantId = 'YOUR_SANDBOX_MERCHANT_ID';
   const isProduction = false; // Sandbox mode
   ```

3. **Test payment flow**:
   - Use test UPI IDs: `success@ybl` (success), `failure@ybl` (failure)
   - PhonePe Simulator will show all payment options
   - Complete payment → Returns to app

### 🚀 For Production (Later)

You can optionally add a **custom UPI app selector** before calling PhonePe SDK:

1. **Uncomment UPI selector import**:
   ```dart
   import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/upi_app_selector.dart';
   ```

2. **Add selector before payment**:
   ```dart
   // Show UPI app selector
   final selectedApp = await UpiAppSelectorSheet.show(
     context, 
     upiApps,
     amount: widget.gatewayAmount,
     showPhonePeOption: true,
   );
   
   // Then call PhonePe SDK
   final result = await _phonePeService.startPayment(...);
   ```

**Note**: Even with selector, PhonePe SDK will still show all payment options. The selector is just for better UX (directly opening specific UPI apps).

## Backend Response Format

Backend returns payment data in this format:
```json
{
  "appointmentId": "...",
  "status": "CREATED",
  "paymentRequired": true,
  "payment": {
    "merchantTransactionId": "...",
    "totalAmount": 500,
    "walletAmount": 0,
    "gatewayAmount": 500,
    "provider": "GATEWAY",
    "token": "eyJvcmRlcklkIjoi...", // base64 request for PhonePe SDK
    "orderId": "PP_ORDER_123",
    "expiresAt": "2025-01-20T10:30:00Z"
  }
}
```

The `token` field contains the base64-encoded request that PhonePe SDK needs.

## Deep Link Setup

### Android (`AndroidManifest.xml`)
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="ecliniq" />
</intent-filter>
```

### iOS (`Info.plist`)
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>ecliniq</string>
    </array>
  </dict>
</array>
```

## Debugging

Check logs for:
- `PHONEPE SDK INIT` - SDK initialization
- `STARTING PHONEPE PAYMENT` - Payment initiation
- `PHONEPE SDK RESPONSE` - Payment result from SDK
- `VERIFYING PAYMENT` - Backend verification

## Common Issues

**Q: PhonePe app doesn't open?**
- Check if PhonePe Simulator is installed (sandbox)
- Check if `isProduction` flag matches your environment
- Verify `merchantId` is correct

**Q: Payment completes but app doesn't return?**
- Check deep link setup (`ecliniq://` scheme)
- Verify `appSchema` matches your URL scheme

**Q: Want to test specific UPI apps?**
- Use PhonePe SDK - it shows all installed UPI apps
- Or add custom selector (see "For Production" section)

## Summary

✅ **Current flow**: Click confirm → PhonePe opens → Select payment → Pay → Return → Verify → Success

✅ **PhonePe SDK handles**: App selection, payment methods, UPI apps, Cards, Net Banking

✅ **For testing**: Use PhonePe Simulator with sandbox credentials

✅ **For production**: Can add custom UPI selector for better UX (optional)


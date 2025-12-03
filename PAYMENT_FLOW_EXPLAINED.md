# Payment Flow Explained

## How Payment Works

### 1. Booking Appointment
When user books an appointment:
- Backend creates payment record
- Returns payment token (JWT) if gateway payment needed
- Flutter app receives: `{ paymentRequired: true, payment: { token, ... } }`

### 2. Payment Screen
Payment Processing Screen opens and:
- Initializes PhonePe SDK (SANDBOX or PRODUCTION)
- Gets list of installed UPI apps
- Shows payment method selector

### 3. Payment Method Selection
User sees two options:

#### Option A: "Pay with PhonePe" (Recommended)
- Opens PhonePe app/simulator
- PhonePe shows ALL payment options:
  - ✅ UPI Apps (PhonePe, Google Pay, Paytm, etc.)
  - ✅ UPI ID (manual entry)
  - ✅ Debit/Credit Card
  - ✅ Net Banking
  - ✅ PhonePe Wallet
- User chooses any method and completes payment

#### Option B: Select Specific UPI App
- Opens the selected UPI app directly
- User completes payment in that app

### 4. Payment Completion
- PhonePe/UPI app processes payment
- Redirects back to your app via deep link: `ecliniq://callback`
- App verifies payment status with backend
- Shows success/failure screen

## Testing with PhonePe Simulator

### Setup
1. Install **PhonePe Simulator** from Play Store
2. Ensure `isProduction = false` in code
3. Merchant ID: `M237OHQ3YCVAO_2511191950`

### Test Flow
1. Book appointment → Payment screen opens
2. Select "Pay with PhonePe"
3. PhonePe Simulator opens
4. Choose payment method:
   - **UPI**: Use `success@ybl` (success) or `failure@ybl` (failure)
   - **Card**: Use test card numbers
5. Complete payment
6. App returns and verifies payment

### Test Credentials (Sandbox)
- **UPI Success**: `success@ybl`
- **UPI Failure**: `failure@ybl`
- **Card**: Check PhonePe sandbox docs for test cards

## Payment Methods Available

### Via PhonePe (All Methods)
When user selects "Pay with PhonePe":
- PhonePe app opens
- Shows complete payment options:
  - All installed UPI apps
  - UPI ID entry field
  - Card payment
  - Net Banking
  - Wallet

### Via Direct UPI App
When user selects specific UPI app:
- That app opens directly
- User pays using that app only

## Code Flow

```
Booking → Backend → Payment Token → Flutter
  ↓
Payment Screen → Initialize PhonePe SDK
  ↓
Get UPI Apps → Show Selector
  ↓
User Selects → PhonePe/UPI App Opens
  ↓
Payment Complete → Deep Link → Verify → Success Screen
```

## Key Points

1. **PhonePe SDK handles payment method selection** - You don't need separate UI for UPI ID, Card, etc.
2. **"Pay with PhonePe" shows all options** - Best user experience
3. **Direct UPI app selection** - Faster if user has preferred app
4. **Sandbox testing** - Use PhonePe Simulator with test credentials
5. **Production** - Switch `isProduction = true` and use real PhonePe app

## Debugging

Check logs for:
- `PHONEPE SDK INIT` - SDK initialization
- `UPI APPS` - List of found apps
- `STARTING PHONEPE PAYMENT` - Payment initiation
- `PHONEPE PAYMENT RESULT` - Payment result

## Common Questions

**Q: How to test UPI ID payment?**
A: Select "Pay with PhonePe", then in PhonePe choose "Enter UPI ID" option.

**Q: How to test Card payment?**
A: Select "Pay with PhonePe", then in PhonePe choose "Card" option.

**Q: Can I skip UPI app selector?**
A: Yes, you can directly call `startPayment()` without showing selector - PhonePe will show all options.

**Q: What if no UPI apps installed?**
A: "Pay with PhonePe" option is always available - PhonePe will show all payment methods.


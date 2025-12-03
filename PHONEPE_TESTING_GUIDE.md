# PhonePe Payment Testing Guide

## 🧪 Testing PhonePe Payment Integration

### Prerequisites

1. **Install PhonePe Simulator (for Sandbox Testing)**
   - Download from Play Store: Search "PhonePe Simulator"
   - Package: `com.phonepe.simulator`
   - This is required for testing in SANDBOX mode

2. **Configure Environment**
   - Current setting: `isProduction = false` (SANDBOX mode)
   - Merchant ID: `M237OHQ3YCVAO_2511191950`
   - App Schema: `ecliniq`

### Testing Flow

#### Step 1: Book an Appointment
1. Navigate to booking screen
2. Fill appointment details
3. Click "Proceed to Payment"
4. Backend should return payment token

#### Step 2: Payment Screen Opens
1. Payment Processing Screen appears
2. Shows "Checking for UPI apps..."
3. Displays UPI app selector (if apps found)
4. OR shows fallback list of common UPI apps

#### Step 3: Select Payment Method
When you select a UPI app:
1. PhonePe SDK opens the selected app OR
2. PhonePe Simulator opens (in sandbox mode)
3. PhonePe will show payment options:
   - **UPI Apps**: PhonePe, Google Pay, Paytm, etc.
   - **UPI ID**: Enter UPI ID manually
   - **Card**: Debit/Credit card payment
   - **Net Banking**: Bank selection

#### Step 4: Complete Payment in PhonePe
1. In PhonePe Simulator (Sandbox):
   - Use test credentials
   - Select any payment method
   - Complete the payment flow
   
2. In Real PhonePe App (Production):
   - Use your actual UPI/Card
   - Complete payment

#### Step 5: Return to App
1. After payment, PhonePe redirects back to app
2. App verifies payment status
3. Shows success/failure screen

### Sandbox Test Credentials

When using PhonePe Simulator, you can test with:

**UPI Payment:**
- UPI ID: `success@ybl` (for successful payment)
- UPI ID: `failure@ybl` (for failed payment)

**Card Payment:**
- Card Number: Use test cards from PhonePe documentation
- CVV: Any 3 digits
- Expiry: Any future date

**Note**: Check PhonePe sandbox documentation for latest test credentials

### Debugging

#### Check Logs
Look for these log messages:
```
========== PHONEPE SDK INIT ==========
========== UPI APPS ==========
========== STARTING PHONEPE PAYMENT ==========
========== PHONEPE PAYMENT RESULT ==========
```

#### Common Issues

1. **PhonePe Simulator not opening**
   - Ensure `isProduction = false`
   - Check if PhonePe Simulator is installed
   - Verify package name: `com.phonepe.simulator`

2. **Payment options not showing**
   - PhonePe SDK handles payment method selection
   - It will show UPI apps, UPI ID, Card options automatically
   - No need to implement separate UI for these

3. **App not returning after payment**
   - Check deep link configuration
   - Test deep link: `adb shell am start -a android.intent.action.VIEW -d "ecliniq://callback"`

### Payment Methods Available in PhonePe

PhonePe SDK automatically provides these options:

1. **UPI Apps**: All installed UPI apps
2. **UPI ID**: Manual UPI ID entry
3. **Card**: Debit/Credit card
4. **Net Banking**: Bank selection
5. **Wallet**: PhonePe wallet (if available)

You don't need to implement separate UI for these - PhonePe handles it!

### Testing Checklist

- [ ] PhonePe Simulator installed
- [ ] Booking flow works
- [ ] Payment screen opens
- [ ] UPI app selector shows (or fallback list)
- [ ] PhonePe Simulator opens when app selected
- [ ] Payment options visible in PhonePe (UPI, Card, etc.)
- [ ] Can complete test payment
- [ ] App returns after payment
- [ ] Payment status verified correctly

### Next Steps

1. Test with PhonePe Simulator first
2. Verify all payment methods work
3. Test success and failure scenarios
4. Switch to production when ready


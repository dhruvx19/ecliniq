// import 'package:ecliniq/ecliniq_services/phonepe_service.dart';
// import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
// import 'package:flutter/material.dart';

// /// Bottom sheet to select UPI app for payment
// class UpiAppSelectorSheet extends StatelessWidget {
//   final List<UpiApp> upiApps;
//   final Function(UpiApp?) onAppSelected;
//   final double? amount;
//   final bool showPhonePeOption;

//   const UpiAppSelectorSheet({
//     super.key,
//     required this.upiApps,
//     required this.onAppSelected,
//     this.amount,
//     this.showPhonePeOption = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle bar
//           Container(
//             margin: const EdgeInsets.only(top: 12, bottom: 8),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
          
//           // Title
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.payment, color: Color(0xFF1976D2)),
//                     const SizedBox(width: 12),
//                     Text(
//                       'Select Payment App',
//                       style: EcliniqTextStyles.headlineLarge.copyWith(
//                         color: const Color(0xff424242),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (amount != null) ...[
//                   const SizedBox(height: 8),
//                   Text(
//                     'Amount to pay: ₹${amount!.toStringAsFixed(0)}',
//                     style: EcliniqTextStyles.headlineMedium.copyWith(
//                       color: const Color(0xff424242),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     showPhonePeOption
//                         ? 'Choose a payment method below. PhonePe will show all options (UPI, Card, etc.)'
//                         : 'Tap on an app below to open it and complete payment',
//                     style: EcliniqTextStyles.buttonSmall.copyWith(
//                       color: const Color(0xff626060),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           const Divider(height: 1),

//           // PhonePe Option (shows all payment methods)
//           if (showPhonePeOption)
//             ListTile(
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 12,
//               ),
//               leading: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF5F259F).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.phone_android,
//                   color: Color(0xFF5F259F),
//                   size: 28,
//                 ),
//               ),
//               title: Text(
//                 'Pay with PhonePe',
//                 style: EcliniqTextStyles.headlineMedium.copyWith(
//                   color: const Color(0xff424242),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               subtitle: Text(
//                 'All payment options: UPI apps, UPI ID, Card, Net Banking',
//                 style: EcliniqTextStyles.buttonSmall.copyWith(
//                   color: Colors.grey[600],
//                 ),
//               ),
//               trailing: const Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//                 color: Colors.grey,
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Return PhonePe app or null to use default
//                 onAppSelected(UpiApp(
//                   name: 'PhonePe',
//                   packageName: 'com.phonepe.app',
//                 ));
//               },
//             ),

//           if (showPhonePeOption && upiApps.isNotEmpty)
//             const Divider(height: 1),

//           // UPI Apps List
//           if (upiApps.isEmpty && !showPhonePeOption)
//             Padding(
//               padding: const EdgeInsets.all(32.0),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.info_outline,
//                     size: 48,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No UPI apps found',
//                     style: EcliniqTextStyles.headlineMedium.copyWith(
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Please install a UPI app to continue',
//                     style: EcliniqTextStyles.bodyMedium.copyWith(
//                       color: Colors.grey[500],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             )
//           else if (upiApps.isNotEmpty)
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: upiApps.length,
//               separatorBuilder: (context, index) => const Divider(height: 1),
//               itemBuilder: (context, index) {
//                 final app = upiApps[index];
//                 return ListTile(
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 8,
//                   ),
//                   leading: _buildAppIcon(app),
//                   title: Text(
//                     app.name,
//                     style: EcliniqTextStyles.headlineMedium.copyWith(
//                       color: const Color(0xff424242),
//                     ),
//                   ),
//                   subtitle: app.version != null
//                       ? Text(
//                           'Version ${app.version}',
//                           style: EcliniqTextStyles.buttonSmall.copyWith(
//                             color: Colors.grey[600],
//                           ),
//                         )
//                       : null,
//                   trailing: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 16,
//                     color: Colors.grey,
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                     onAppSelected(app);
//                   },
//                 );
//               },
//             ),

//           // Cancel button
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   onAppSelected(null);
//                 },
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   side: BorderSide(color: Colors.grey[300]!),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'Cancel',
//                   style: EcliniqTextStyles.headlineMedium.copyWith(
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Bottom safe area
//           SizedBox(height: MediaQuery.of(context).padding.bottom),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppIcon(UpiApp app) {
//     // Map of known UPI apps to their icon data
//     IconData iconData;
//     Color iconColor;

//     if (app.isPhonePe) {
//       iconData = Icons.phone_android;
//       iconColor = const Color(0xFF5F259F);
//     } else if (app.isGPay) {
//       iconData = Icons.g_mobiledata;
//       iconColor = const Color(0xFF4285F4);
//     } else if (app.isPaytm) {
//       iconData = Icons.payment;
//       iconColor = const Color(0xFF00BAF2);
//     } else if (app.isBhim) {
//       iconData = Icons.account_balance;
//       iconColor = const Color(0xFFED1C24);
//     } else {
//       iconData = Icons.account_balance_wallet;
//       iconColor = const Color(0xFF1976D2);
//     }

//     return Container(
//       width: 48,
//       height: 48,
//       decoration: BoxDecoration(
//         color: iconColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Icon(
//         iconData,
//         color: iconColor,
//         size: 28,
//       ),
//     );
//   }

//   /// Show UPI app selector bottom sheet
//   static Future<UpiApp?> show(
//     BuildContext context,
//     List<UpiApp> upiApps, {
//     double? amount,
//     bool showPhonePeOption = false,
//   }) async {
//     UpiApp? selectedApp;

//     await showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => UpiAppSelectorSheet(
//         upiApps: upiApps,
//         amount: amount,
//         showPhonePeOption: showPhonePeOption,
//         onAppSelected: (app) {
//           selectedApp = app;
//         },
//       ),
//     );

//     return selectedApp;
//   }
// }

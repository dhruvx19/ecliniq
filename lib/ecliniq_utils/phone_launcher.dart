import 'package:url_launcher/url_launcher.dart';


class PhoneLauncher {
  
  
  
  
  
  static Future<bool> launchPhoneCall(String? phoneNumber) async {
    
    String numberToCall = phoneNumber?.trim() ?? '1234567890';
    
    
    numberToCall = numberToCall.replaceAll(RegExp(r'[^\d+]'), '');
    
    
    if (!numberToCall.startsWith('+')) {
      
      if (numberToCall.length == 10) {
        numberToCall = '+91$numberToCall';
      } else {
        
        numberToCall = '+$numberToCall';
      }
    }
    
    final Uri phoneUri = Uri(scheme: 'tel', path: numberToCall);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }
}




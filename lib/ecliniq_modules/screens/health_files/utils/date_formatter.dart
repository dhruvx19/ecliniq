
class HealthFileDateFormatter {
  
  
  
  
  static String formatDateTime(DateTime date) {
    
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    
    
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    
    
    final hour12 = hour == 0 
        ? 12 
        : hour > 12 
            ? hour - 12 
            : hour;
    final period = hour < 12 ? 'am' : 'pm';
    
    return '$day/$month/$year | $hour12:$minute$period';
  }
  
  
  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
  
  
  static String formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    
    
    final hour12 = hour == 0 
        ? 12 
        : hour > 12 
            ? hour - 12 
            : hour;
    final period = hour < 12 ? 'am' : 'pm';
    
    return '$hour12:$minute$period';
  }
}







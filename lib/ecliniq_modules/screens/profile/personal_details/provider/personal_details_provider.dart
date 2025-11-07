import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PersonalDetailsProvider extends ChangeNotifier {
  bool isPersonalDetailsExpended = true;
  bool isPersonalDetailsExpanded(){
    return isPersonalDetailsExpended;
  }
  void togglePersonalDetails(){
    isPersonalDetailsExpended = !isPersonalDetailsExpended;
    notifyListeners();
  }
  bool isHealthInfoExpended = true;

  bool isHealthInfoExpanded(){
    return isHealthInfoExpended;
  }
  void toggleHealthInfo(){
    isHealthInfoExpended = !isHealthInfoExpended;
  notifyListeners();
  }
}
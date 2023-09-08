import 'package:flutter/cupertino.dart';
import 'package:freevid/Model/Event_Model.dart';

class MainProvider with ChangeNotifier {
  bool hasData = false;

  void setData(bool data) {
    hasData = true;
    notifyListeners();
  }

  bool get getData => hasData;

  bool hasVata = false;

  void setVata(bool data) {
    hasVata = true;
    notifyListeners();
  }

  bool get getVata => hasData;

  List<CreateEvents> createevents=[];
  void setEventData(CreateEvents createEvents){
    createevents.add(createEvents);
    notifyListeners();
  }
  get getEventData=>createevents;

  bool isShow=false;
  void setIsShow(bool val){
    isShow=val;
    notifyListeners();
  }
  get getIsShow=>isShow;
}

import 'package:intl/intl.dart';

class MyDateUtil {
  static String getFormattedStringDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String outputFormat = "d MMM y";
    DateFormat formatter = DateFormat(outputFormat);
    String formattedDate = formatter.format(dateTime);
    print(formattedDate);
    return formattedDate;
  }
  static bool getBeforeString(String date){
    DateTime dateTime=DateTime.parse(date);
    DateTime currentTime=DateTime.now();
    if(dateTime.day==currentTime.day && dateTime.month==currentTime.month && dateTime.year==currentTime.year){
      return true;
    }
    if(dateTime.isAfter(currentTime)){
      return true;
    }
    return false;
  }
}

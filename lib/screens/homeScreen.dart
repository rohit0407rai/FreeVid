import 'package:flutter/material.dart';
import 'package:freevid/Model/Event_Model.dart';
import 'package:freevid/helper/helper_functions.dart';
import 'package:freevid/screens/Home/navHome.dart';
import 'package:freevid/screens/profileScreen.dart';
import 'package:freevid/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../screens/Home/navAllEvent.dart';
import '../api/apis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String date = "";
  String timeRange = "";
  String k = "";
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('FreeVid'),
        backgroundColor: CustomColor().appBar,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_)=>const ProfileScreen()));
                },
                icon: const Icon(Icons.person_2_rounded)),
          ),
        ],
      ),
      backgroundColor: CustomColor().backgroundColor,
      body: _selectedIndex == 0
          ? NavHome(mq: mq)
          : NavAllEvent(mq: mq,),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showBottomSheet(context, mq);
        },
        label: const Text("Add Event"),
        icon: Image.asset(
          "assets/icons/add_button.png",
          fit: BoxFit.fill,
          height: 30,
        ),
        backgroundColor: CustomColor().backgroundColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColor().appBar,
        currentIndex: _selectedIndex,
        selectedIconTheme:
            IconThemeData(size: 32, color: CustomColor().darkCode),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox), label: 'All Events'),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Size mq) {
    bool isCorrect = false;
    TextEditingController eventEditingController = new TextEditingController();
    TextEditingController addInfoController = new TextEditingController();
    FocusNode _eventNameFocusNode = FocusNode();
    FocusNode _addInfoFousNode = FocusNode();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CustomColor().backgroundColor,
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            _eventNameFocusNode.unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 130),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Create Event",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black87),
                          )),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: eventEditingController,
                          focusNode: _eventNameFocusNode,
                          decoration: InputDecoration(
                            label: const Text("Event Name"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: CustomColor().appBar)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              date = await _selectDate(context);
                              print("Date is ${date}");
                              DateTime s = DateTime.parse(date);
                              k = DateFormat("dd/MM/yyyy").format(s);
                              setState(() {});
                              print("Date is ${date} after setState");
                            },
                            child: const Text(
                              "Date",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            date.isEmpty ? "Not Selected" : k,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: MaterialButton(
                              onPressed: () async {
                                timeRange = await _timeRangePicker(context);
                                print(timeRange);

                                setState(() {});
                              },
                              child: const Text(
                                "Time",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Text(
                            timeRange.isEmpty ? "Not Selected" : timeRange,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (isCorrect)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: addInfoController,
                            focusNode: _addInfoFousNode,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Write all the additional info here",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: CustomColor().appBar)),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              isCorrect = !isCorrect;
                            });
                          },
                          icon: isCorrect
                              ? const Icon(Icons.close)
                              : const Icon(Icons.add_circle_outline_sharp),
                          label: isCorrect
                              ? const Text('Cancel')
                              : const Text("Additional Fields")),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (eventEditingController != null &&
                              date != null &&
                              timeRange != null) {
                            Helpers.showProgressBar(context);
                            APIs().createEvent(
                                CreateEvents(
                                  EventId: "${eventEditingController.text.toString()}_${DateTime.now().toString()}",
                                    EventName:
                                        eventEditingController.text.toString(),
                                    Date: date.toString(),
                                    Time: timeRange.toString(),
                                    AdditionalInfo:
                                        addInfoController.text.toString(),present:[]),
                                context);
                          }
                          Navigator.pop(context);
                          eventEditingController.clear();
                          date = "";
                          timeRange = "";
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColor().appBar,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                            minimumSize:
                                Size(mq.width * 0.8, mq.height * 0.06)),
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showClass(BuildContext context, Size mq, String text) {
    return Container(
      height: mq.height * .07,
      width: mq.width * 0.3,
      decoration: BoxDecoration(
        color: CustomColor().appBar.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Initial date displayed when the picker opens
      firstDate: DateTime(2000),
      // Minimum selectable date
      lastDate: DateTime(2101), // Maximu// m selectable date
    );

    if (picked != null && picked != DateTime.now()) {
      // Handle the selected date
      // String k = DateFormat("dd/MM/yyyy").format(picked);
      setState(() {
        date = picked.toLocal().toString();
      });

      return date;
    }
    return "No date";
  }

  Future<String> _timeRangePicker(BuildContext context) async {
    TimeRange pickedTimeRange = await showTimeRangePicker(
      context: context,
      start: TimeOfDay(hour: 0, minute: 0),
      end: TimeOfDay(hour: 23, minute: 59),
      interval: Duration(minutes: 15),
      use24HourFormat: true,
    );

    if (pickedTimeRange != null) {
      String startTime = _formatTime(pickedTimeRange.startTime);
      String endTime = _formatTime(pickedTimeRange.endTime);
      String formattedTimeRange = '$startTime to $endTime';

      setState(() {
        timeRange = formattedTimeRange;
      });
      return timeRange;
    }
    return "No Time Selected ";
  }

  String _formatTime(TimeOfDay timeOfDay) {
    String hour = timeOfDay.hour.toString().padLeft(2, '0');
    String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  List<CreateEvents> filterUpcomingEvents(List<CreateEvents> events) {
    final currentDate = DateTime.now();
    return events.where((event) {
      if (event.Date.isEmpty) {
        return false; // Skip events with no date
      }

      DateTime eventDate = DateTime.parse(event.Date);
      return eventDate.isAfter(currentDate);
    }).toList();
  }

  List<CreateEvents> filterUpcomEvents(List<CreateEvents> events) {
    final currentDate = DateTime.now();
    return events.where((event) {
      if (event.Date.isEmpty) {
        return false; // Skip events with no date
      }

      DateTime eventDate = DateTime.parse(event.Date);
      return (eventDate.day == currentDate.day &&
              eventDate.month == currentDate.month &&
              eventDate.year == currentDate.year)
          ? true
          : false;
    }).toList();
  }
}

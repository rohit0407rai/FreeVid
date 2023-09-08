import 'package:flutter/material.dart';
import 'package:freevid/Model/Event_Model.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/helper/helper_functions.dart';
import 'package:freevid/provider/mainProvider.dart';
import 'package:freevid/screens/students/Attendance.dart';
import 'package:freevid/screens/teachers/optionAttendance.dart';
import 'package:freevid/utils/colors.dart';
import 'package:freevid/utils/myDateUtill.dart';
import 'package:freevid/widgets/named_card.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:provider/provider.dart';
import '../../widgets/eventCard.dart';

class NavHome extends StatefulWidget {
  final Size mq;

  const NavHome({super.key, required this.mq});

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  String date = "";
  String timeRange = "";
  bool clicked = false;
  String k = "";
  bool hasData = false;
  bool hasVata = false;
  int _selectedIndex = 0;
  List<CreateEvents> klist = [];
  List<CreateEvents> klists = [];

  @override
  Widget build(BuildContext context) {
    // MainProvider homeProvider=Provider.of<MainProvider>(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            CustomColor().darkCode,
            CustomColor().backgroundColor,
            CustomColor().darkCode
          ])),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StudentAttendScan()));
                    },
                    child: NamedCard(
                      size: widget.mq,
                      image: 'assets/images/graduates.png',
                      text: "Students",
                    )),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TeacherAttendScreen()));
                    },
                    child: NamedCard(
                      size: widget.mq,
                      image: 'assets/images/teacher.png',
                      text: "Teachers",
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Today Events",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Flexible(
                child: Container(
              height: 150,
              child: StreamBuilder(
                stream: APIs().getEventData(),
                builder: (context, snapshot) {
                  final list = snapshot.data?.docs ?? [];
                  final jj =
                      list.map((e) => CreateEvents.fromJson(e.data())).toList();

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (list.isNotEmpty) {
                        klists = filterUpcomEvents(jj);
                        print(klists);
                        if (klists.isNotEmpty) {
                          hasData = true;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: klists!.length,
                            itemBuilder: (context, index) {
                              // homeProvider.setEventData(klists[index]);
                              return Padding(
                                padding: EdgeInsets.only(left: 10),
                                // child: showEventCard(context, widget.mq, klists[index].EventName, klists[index].Date,)
                                child: EventCard(
                                  createEvents: klists[index],
                                    mq: widget.mq,
                                    name: klists[index].EventName,
                                    date: MyDateUtil.getFormattedStringDate(
                                        klists[index].Date)),
                              );
                            },
                          );
                        }
                      } else {
                        const Text("No Upcoming Event Found");
                      }
                  }
                  return Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: IconButton(
                        onPressed: () {
                          _showBottomSheet(context, widget.mq);
                        },
                        icon: Icon(
                          Icons.add_circle_outline_sharp,
                          size: 60,
                        )),
                  );
                },
              ),
            )),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Upcoming Events",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Flexible(
                child: Container(
              height: 150,
              child: StreamBuilder(
                stream: APIs().getEventData(),
                builder: (context, snapshot) {
                  final list = snapshot.data?.docs ?? [];
                  final k =
                      list.map((e) => CreateEvents.fromJson(e.data())).toList();

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (list.isNotEmpty) {
                        klist = filterUpcomingEvents(k);

                        if (klist.isNotEmpty) {
                          hasVata = true;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: klist!.length,
                            itemBuilder: (context, index) {
                              // homeProvider.setEventData(klist[index]);
                              return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: EventCard(
                                      createEvents: klist[index],
                                      mq: widget.mq,
                                      name: klist[index].EventName,
                                      date: MyDateUtil.getFormattedStringDate(
                                          klist[index].Date)));
                            },
                          );
                        }
                      } else {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    _showBottomSheet(context, widget.mq);
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outline_sharp,
                                    size: 60,
                                  )),
                              Text("Currently No events Lined up")
                            ],
                          ),
                        );
                      }
                  }
                  return Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                            onPressed: () {
                              _showBottomSheet(context, widget.mq);
                            },
                            icon: Icon(
                              Icons.add_circle_outline_sharp,
                              size: 60,
                            )),
                        Text("Currently No events Lined up")
                      ],
                    ),
                  );
                },
              ),
            )),
            const SizedBox(
              height: 10,
            ),
          ]),
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
                                        addInfoController.text.toString(), present: []),
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

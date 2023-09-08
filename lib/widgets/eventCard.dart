import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freevid/Model/Event_Model.dart';
import 'package:freevid/screens/students/mark_student_attendance.dart';
import 'package:freevid/utils/colors.dart';
import 'package:freevid/widgets/scroll_user_card.dart';
import '../screens/modelAttendance/user_Attendance.dart';
class EventCard extends StatefulWidget {
  final CreateEvents createEvents;
  final Size mq;
  final String name;
  final String date;

  const EventCard(
      {super.key, required this.mq, required this.name, required this.date, required this.createEvents});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  List<String> i = [
    "assets/images/s1.png",
    "assets/images/s2.png",
    "assets/images/s3.png",
    "assets/images/s4.png"
  ];

  int getNumber() {
    Random random = Random();
    int number = random.nextInt(4);
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>UserAttendance(createEvents: widget.createEvents,)));
      },
      child: Container(
        width: 150,
        // Adjust this value based on your layout
        height: 180,
        // This will ensure the container is a square
        margin: const EdgeInsets.all(10),
        // Adjust the spacing
        decoration: BoxDecoration(
          color: CustomColor().appBar,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: ScrollUserCard(
          image: i[getNumber()],
          size: widget.mq,
          text: widget.name,
          date: widget.date,
        )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/screens/students/mark_student_attendance.dart';
import './register_student.dart';
import 'package:freevid/utils/colors.dart';
import 'package:freevid/utils/utils.dart';

class StudentAttendScan extends StatefulWidget {
  const StudentAttendScan({super.key});

  @override
  State<StudentAttendScan> createState() => _StudentAttendScanState();
}

class _StudentAttendScanState extends State<StudentAttendScan> {
  void initState() {
    // printIfDebug(LocalDB.getUser().name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Attendance"),
        backgroundColor: CustomColor().appBar,
        centerTitle: true,
      ),
      backgroundColor: CustomColor().backgroundColor,
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              buildButton(text: 'Register', icon: Icons.app_registration, onClicked:(){
                Navigator.push(context,MaterialPageRoute(builder: (_)=>const RegisterStudent()));

              }),
              SizedBox(height: 20,),
              buildButton(text: 'Mark Attendance', icon: Icons.app_registration, onClicked:(){
                Navigator.push(context,MaterialPageRoute(builder: (_)=>const MarkStudentAttendance()));

              })
            ],
          )
        ),
      ),
    );
  }

  Widget buildButton(
          {required String text,
          required IconData icon,
          required VoidCallback onClicked}) =>
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: CustomColor().appBar,
          ),
          onPressed: onClicked,
          icon: Icon(
            icon,
            size: 26,
            color: Colors.black87,
          ),
          label: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.black87),
          ));
}

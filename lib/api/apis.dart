import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freevid/Model/Event_Model.dart';
import 'package:freevid/Model/Student_Model.dart';
import 'package:freevid/Model/Student_Show_Model.dart';
import 'package:freevid/Model/Teacher_Model.dart';
import 'package:freevid/helper/helper_functions.dart';
import 'package:freevid/screens/auth/admin_login.dart';
import 'package:freevid/screens/homeScreen.dart';

class APIs {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  User? user = firebaseAuth.currentUser;

  void register(String validemail, String validpassword, BuildContext context,
      String name) {
    Helpers.showProgressBar(context);
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: validemail, password: validpassword)
        .then((value) {
      addUser(value.user!.uid, validemail, name);
      Navigator.pop(context);
      Helpers.showSnackBar(context, "Registered Succesfully", Colors.green);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }).catchError((error) {
      Navigator.pop(context);
      Helpers.showSnackBar(context, error.toString(), Colors.red);
    });
  }

  void addUser(String id, String email, String name) async {
    await firestore
        .collection('Admin')
        .doc(id)
        .set({'name': name, 'email': email});
  }

  void loginUser(String email, String password, BuildContext context) {
    Helpers.showProgressBar(context);
    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.pop(context);
      Helpers.showSnackBar(context, "Login Succesful", Colors.green);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      Helpers.showSnackBar(context, error.toString(), Colors.red);
    });
  }

  void signOut(BuildContext context) {
    firebaseAuth.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => AdminLogin()));
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Students').get();
    // return firestore.collection('Students').get();
    return querySnapshot;
  }

  void registerStudent(Students student, BuildContext context) async {
    await firestore
        .collection('Students')
        .doc(student.StudentId)
        .set(student.toJson());
  }

  void registerTeacher(Teachers teacher, BuildContext context) async {
    await firestore
        .collection('Teachers')
        .doc(teacher.teacherId)
        .set(teacher.toJson());
  }

  Future<String> addPicture(File file, String id) async {
    final ext = file.path.split('.').last;
    print(ext);
    final ref = storage.ref().child('students/${id}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('data transfered');
    });
    String jurl = await ref.getDownloadURL();
    return jurl;
  }

  Future<String> addTeacherPicture(File file, String id) async {
    final ext = file.path.split('.').last;
    print(ext);
    final ref = storage.ref().child('teachers/${id}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('data transfered');
    });
    String jurl = await ref.getDownloadURL();
    return jurl;
  }

  void updateAttendance(String id) async {
    await firestore.collection('Students').doc(id).update({
      'total_attendance': FieldValue.increment(1),
      'last_attendance': DateTime.now().toString()
    });
  }

  void createEvent(CreateEvents events, BuildContext context) async {

    await firestore
        .collection('events')
        .doc(events.EventId)
        .set(events.toJson())
        .then((value) {
      Navigator.pop(context);
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getEventData() {
    return firestore.collection("events").snapshots();
  }
  void updateStudentAttendance(CreateEvents events, StudentShow studentShow) async{
    firestore.collection("events").doc(events.EventId).update({
      "present":FieldValue.arrayUnion([studentShow.toJson()]),
    });
  }
  Future<QuerySnapshot<Map<String,dynamic>>> fetchOnlySelectedClassData(String studentClass){
    return firestore.collection("Students").where("Class", isEqualTo: studentClass).get();
  }
  Stream<DocumentSnapshot<Map<String,dynamic>>> fetchMarkedAttendanceStudent(String docId){
    return firestore.collection("events").doc(docId).snapshots();
  }
  void deleteEvent(String docId, BuildContext context){
    firestore.collection("events").doc(docId).delete().then((value){
      Helpers.showSnackBar(context, "Deleted Succesfully", Colors.red);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
  Stream<DocumentSnapshot<Map<String,dynamic>>>  getAdminName(String AdminId){
    return firestore.collection('Admin').doc(AdminId).snapshots();
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freevid/Model/Student_Model.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/helper/helper_functions.dart';
import 'package:freevid/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MarkStudentAttendance extends StatefulWidget {
  const MarkStudentAttendance({super.key});

  @override
  State<MarkStudentAttendance> createState() => _MarkStudentAttendanceState();
}

class _MarkStudentAttendanceState extends State<MarkStudentAttendance> {
  List<Students> students = [];
  List<String> urls = [];
  String nm = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await APIs().fetchData();

      List<Students> fetchedStudents = querySnapshot.docs
          .map((doc) => Students.fromJson(doc.data()))
          .toList();
      setState(() {
        students = fetchedStudents;
      });
      urls = students.map((val) => val.image).toList();
      print(urls);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  String? _im;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Student Attendance"),
        centerTitle: true,
        backgroundColor: CustomColor().appBar,
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
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: mq.height * 0.2,
              width: mq.width * 0.4,
              decoration: BoxDecoration(
               shape: BoxShape.circle,
                color:CustomColor().appBar,
              ),
              child: _im == null
                  ? InkWell(
                      child: const Icon(
                        Icons.person,
                        size: 100,
                      ),
                      onTap: () {
                        imagePick();
                      },
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular((mq.height * 0.6)/2),

                      child: InkWell(
                          onTap: () {
                            imagePick();
                          },
                          child: Image.file(
                            File(_im!),
                            fit: BoxFit.cover,
                          )),
                    ),
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: buildButton(text: "Mark Attendance", onClicked:(){
                postData(File(_im!), urls);
              }),
            ),
          ],
        ),
      ),
    );
  }

  void imagePick() async {
    ImagePicker _imagePicker = ImagePicker();
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      String compressedImagePath = await compressImage(image.path);
      setState(() {
        // _im=image.path.toString();
        _im = compressedImagePath;
      });
      File capturedImage = File(_im!);
    }
  }

  Future<String> compressImage(String imagePath) async {
    Uint8List? compressedImageBytes =
        await FlutterImageCompress.compressWithFile(imagePath,
            format: CompressFormat.jpeg,
            minHeight: 250,
            minWidth: 250 // Adjust the quality as needed
            );

    if (compressedImageBytes == null) {
      throw Exception('Image compression failed.');
    }

    // Create a new file with the converted image
    File compressedImageFile = File(imagePath)
      ..writeAsBytesSync(compressedImageBytes);

    return compressedImageFile.path;
  }

  // void scan_face(File file, List urls) async {
  //   List<int> imageBytes = await file.readAsBytes();
  //   String base64Image = base64Encode(imageBytes);
  //   String urlsString = urls.join(',');
  //
  //
  //   var response= http.post(Uri.parse('http://10.0.2.2:5000/api/compare'),body:{
  //     'image':base64Image,
  //     'image_urls':urlsString
  //   } );
  // }

  Future<void> postData(File inputImage, List<String> imageUrls) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://6843-2401-4900-1720-9ba0-8ff-3f4e-4ff7-5948.ngrok-free.app/api/compare'),
      );

      // Add the input image to the request
      request.files.add(
        await http.MultipartFile.fromPath('image', inputImage.path),
      );

      // Add the image URLs to the request
      request.fields['image_urls'] = imageUrls.join(',');

      // Send the request and get the response
      var response = await request.send();

      // Check if the response was successful
      if (response.statusCode == 200) {
        // Read and print the response
        var responseString = await response.stream.bytesToString();
        print(responseString);
        var m = jsonDecode(responseString);
        nm = remoVeWaste(m['name']);
        String nim="";
        students.forEach((e) {
          if (e.StudentId == nm) {
            print(e.Name);
            nim=e.Name;
          }
        });
        APIs().updateAttendance(nm);
        Helpers.showSnackBar(context,"${nim}'s attendance is marked", Colors.green);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting data: $error');
    }
  }

  String remoVeWaste(String name) {
    String j = name.replaceFirst("students/", "");

    String s = j.replaceFirst(".jpg", "");

    return s;
  }

  Widget buildButton(
      {required String text,
        required VoidCallback onClicked}) =>
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: CustomColor().appBar,
          ),
          onPressed: onClicked,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ));
}

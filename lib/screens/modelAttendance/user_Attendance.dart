import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freevid/Model/Event_Model.dart';
import 'package:freevid/Model/Student_Model.dart';
import 'package:freevid/Model/Student_Show_Model.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/helper/helper_functions.dart';
import 'package:freevid/utils/colors.dart';
import 'package:freevid/utils/myDateUtill.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserAttendance extends StatefulWidget {
  final CreateEvents createEvents;
  const UserAttendance({super.key, required this.createEvents});

  @override
  State<UserAttendance> createState() => _UserAttendanceState();
}

class _UserAttendanceState extends State<UserAttendance> {
  List<Students> students = [];
  List<String> urls = [];
  String nm = "";
  String selectedValue="Please Select Class";
  @override
  void initState() {
    super.initState();

  }

  Future<void> fetchData(String val) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await APIs().fetchOnlySelectedClassData(val);

      List<Students> fetchedStudents = querySnapshot.docs
          .map((doc) => Students.fromJson(doc.data()))
          .toList();
      setState(() {
        students = fetchedStudents;
      });
      urls = students.map((val) => val.image).toList();
      print(urls);
      print("data us coming");
      print(students);
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
        actions: [
          IconButton(onPressed: (){
            Helpers.showsDialog(context, widget.createEvents);
          }, icon: const Icon(Icons.delete_forever))
        ],
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              if(MyDateUtil.getBeforeString(widget.createEvents.Date))...[

                const SizedBox(height: 10,),
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
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: CustomColor().appBar,
                      borderRadius: BorderRadius.circular(22)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 2,),
                      const Text("Select class"),
                      DropdownButton(
                          value: selectedValue,
                          items: ['7','8','9','10','Please Select Class'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(), onChanged: (newValue){
                        setState(() {
                          selectedValue=newValue as String ;
                          print(selectedValue);
                        });
                        fetchData(selectedValue);
                      }),
                      const SizedBox(width: 2,)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                urls.isNotEmpty?Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: buildButton(text: "Mark Attendance", onClicked:(){
                    Helpers.showProgressBar(context);
                    postData(File(_im!), urls).then((value) {
                      Navigator.pop(context);
                    });
                  }),
                ):Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: buildButton(text: selectedValue=="Please Select Class"?"Select from dropdown":"No Data in ${selectedValue} class", onClicked:(){
                  }),
                ),
              ],

              SizedBox(height: mq.height*0.04,),

              StreamBuilder(
                stream: APIs().fetchMarkedAttendanceStudent(widget.createEvents.EventId),
                builder: (context, snapshot) {
                  final z=snapshot.data?.data();
                  CreateEvents k;


                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(z!=null){
                        k=CreateEvents.fromJson(z);
                        print(k.present);

                        return Container(
                        height: k.present.isNotEmpty?mq.height*0.65:mq.height*0.3,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        decoration: BoxDecoration(color: CustomColor().appBar.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Students Present', style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),),
                            k.present.isNotEmpty?Flexible(child: ListView.builder(
                                itemCount: k.present.length,
                                itemBuilder: (context,index){
                                  return Container(

                                    margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: CustomColor().appBar,
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          radius: 30,
                                          child: Text("${index+1}", style: TextStyle(fontSize: 18),)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      title: Text(k.present[index]['name']),
                                      subtitle: Text(k.present[index]['id']),

                                    ),
                                  );
                                })):Container(
                              margin: const EdgeInsets.symmetric(vertical: 80),
                              child: const Center(
                                child: Text("No Student Marked", style: TextStyle(color: Colors.grey),),
                              ),
                            )
                          ],
                        ),
                        );
                      }
                      return SizedBox();
                  }
                }
              )

            ],
          ),
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
        minHeight: 200,
        minWidth: 200 // Adjust the quality as needed
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
        APIs().updateStudentAttendance(widget.createEvents,StudentShow(name: nim, id: nm));
      } else {
        print('Error: ${response.statusCode}');
        if(response.statusCode==400){
          Helpers.showSnackBar(context, "Not able to reach Servers", Colors.red);
        }
        if(response.statusCode==500){
          Helpers.showSnackBar(context, "Internal Server Issue", Colors.red);
        }
      }
    } catch (error) {
      print('Error posting data: $error');
      Helpers.showSnackBar(context, "${error} Server Issue", Colors.red);
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

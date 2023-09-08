import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freevid/Model/Student_Model.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/helper/helper_functions.dart';
import 'package:freevid/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
class RegisterStudent extends StatefulWidget {
  const RegisterStudent({super.key});

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {

  final formKey = GlobalKey<FormState>();
  String studentId="";
  String studentName="";
  String schoolName="";
  String studentClass="";
  String? _im;
  String iurl="";
  String selectedValue="7";

  @override
  Widget build(BuildContext context) {
    Size mq=MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
        title: const Text("Register Student"),
        centerTitle: true,
        backgroundColor: CustomColor().appBar,
      ) ,
      backgroundColor: CustomColor().backgroundColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  CustomColor().darkCode,
                  CustomColor().backgroundColor,
                  CustomColor().darkCode
                ])),
        child:SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Stack(
                  children: [
                    Container(
                      height: mq.height*0.2,
                      width: mq.width*0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mq.height*0.15),
                        color: CustomColor().appBar,
                      ),
                      child: _im==null?InkWell(child: const Icon(Icons.person,size: 100,), onTap: (){
                        imagePick();
                      },):ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: InkWell(
                            onTap: (){
                              imagePick();
                            },
                            child: Image.file(File(_im!), fit: BoxFit.fill,)),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: mq.height*0.05,
                            width: mq.width*0.1,
                            decoration: BoxDecoration(
                              color: CustomColor().appBar,
                              shape: BoxShape.circle

                            ),
                            child: IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.black,),)))
                  ],
                ),
                const SizedBox(height:20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: CustomColor().appBar,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        label: const Text('Student Id', style: TextStyle(color: Colors.black),)),
                    validator: (String? value){
                      String k=value.toString().trim();
                      if(k!.isEmpty){
                        return "Please enter student id";
                      }
                    },
                    onSaved: (String? value) {
                      String j=value.toString().trim();
                      studentId=j.toString();
                    },
                  ),
                ),
                const SizedBox(height:20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: CustomColor().appBar,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        label: const Text('Student Name', style: TextStyle(color: Colors.black),)),
                    validator: (String? value){
                      String k=value.toString().trim();
                      if(k!.isEmpty){
                        return "Please enter student id";
                      }
                    },
                    onSaved: (String? value) {
                      String j=value.toString().trim();
                      studentName=j.toString();
                    },
                  ),
                ),
                const SizedBox(height:20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: CustomColor().appBar,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                      hintText: "What's your School Name?"
                       ),

                    validator: (String? value){
                      String k=value.toString().trim();
                      if(k!.isEmpty){
                        return "Please enter student id";
                      }
                    },
                    onSaved: (String? value) {
                      String j=value.toString().trim();
                      schoolName=j.toString();
                    },
                  ),
                ),
                const SizedBox(height:20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 22),
                //   child: TextFormField(
                //     decoration: InputDecoration(
                //         prefixIcon: Icon(
                //           Icons.perm_identity,
                //           color: CustomColor().appBar,
                //         ),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10)),
                //         focusedBorder:const OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.black87)
                //         ),
                //         hintText: "What class you are currently studying?"
                //     ),
                //
                //     validator: (String? value){
                //       if(value!.isEmpty){
                //         return "Please dont leave the field blank";
                //       }
                //     },
                //     onSaved: (String? value) {
                //       studentClass=value.toString();
                //     },
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Select your class"),
                    DropdownButton(
                        value: selectedValue,
                        items: ['7','8','9','10'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(), onChanged: (newValue){
                      setState(() {
                            selectedValue=newValue as String ;
                            print(selectedValue);
                      });
                    }),
                  ],
                ),
                SizedBox(height:30),
                ElevatedButton(onPressed: () async {
                  Helpers.showProgressBar(context);
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    // usernameController="";
                    // passwordController="";
                    iurl= await APIs().addPicture(File(_im!), studentId) ;
                    Future.delayed(Duration(seconds: 2), () {
                      APIs().registerStudent(Students(School: schoolName, lastAttendance: DateTime.now().toString(), Class: selectedValue, totalAttendance: 0, Name: studentName, StudentId: studentId,image: iurl), context);
                    }).then((value) {
                      Navigator.pop(context);
                      formKey.currentState!.reset();
                      setState(() {
                        _im=null;
                      });

                    });



                  }

                }, child: const Text('Register', style:TextStyle(color: Colors.black),),style: ElevatedButton.styleFrom(backgroundColor: CustomColor().appBar,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)), minimumSize: Size(mq.width*0.8, mq.height*0.06)),),
              ],
            ),
          ),
        )
      ),
    );
  }
  void imagePick() async{
      ImagePicker _imagePicker=ImagePicker();
      final XFile? image= await _imagePicker.pickImage(source: ImageSource.camera);

     if(image!=null){
       String compressedImagePath = await compressImage(image.path);
       setState(() {
         _im=compressedImagePath;
       });
       File capturedImage=File(_im!);
     }

  }
  Future<String> compressImage(String imagePath) async {
    Uint8List? compressedImageBytes = await FlutterImageCompress.compressWithFile(
        imagePath,
        format: CompressFormat.jpeg,
        minHeight: 250,
        minWidth: 250// Adjust the quality as needed
    );

    if (compressedImageBytes == null) {
      throw Exception('Image compression failed.');
    }

    // Create a new file with the converted image
    File compressedImageFile = File(imagePath)..writeAsBytesSync(compressedImageBytes);

    return compressedImageFile.path;
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freevid/Model/Student_Model.dart';
import 'package:freevid/Model/Teacher_Model.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({super.key});

  @override
  State<RegisterTeacher> createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {
  final formKey = GlobalKey<FormState>();
  String teacherId="";
  String teacherName="";
  String? _im;
  String iurl="";
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
          child:Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            label: const Text('Teacher Id', style: TextStyle(color: Colors.black),)),
                        validator: (String? value){
                          if(value!.isEmpty){
                            return "Please enter teacher id";
                          }
                        },
                        onSaved: (String? value) {
                          teacherId=value.toString();
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
                            label: const Text('Teacher Name', style: TextStyle(color: Colors.black),)),
                        validator: (String? value){
                          if(value!.isEmpty){
                            return "Please enter teacher Name";
                          }
                        },
                        onSaved: (String? value) {
                          teacherName=value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height:20),

                    SizedBox(height:30),
                    ElevatedButton(onPressed: () async {
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        // usernameController="";
                        // passwordController="";
                        iurl= await APIs().addTeacherPicture(File(_im!), teacherId);
                        Future.delayed(Duration(seconds: 1),(){
                          APIs().registerTeacher(Teachers(teacherId: teacherId, teacherName: teacherName, totalAttendance: 0, lastAttendance: DateTime.now().toString(), image: iurl), context);
                        });



                      }

                    }, child: const Text('Register', style:TextStyle(color: Colors.black),),style: ElevatedButton.styleFrom(backgroundColor: CustomColor().appBar,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)), minimumSize: Size(mq.width*0.8, mq.height*0.06)),),
                  ],
                ),
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
      setState(() {
        _im=image.path.toString();
      });
      File capturedImage=File(_im!);
    }

  }
}

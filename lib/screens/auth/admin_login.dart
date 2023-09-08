import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/screens/auth/admin_register.dart';
import 'package:freevid/screens/homeScreen.dart';
import 'package:freevid/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './admin_login.dart';
class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final formKey = GlobalKey<FormState>();
  String usernameController="";
  String passwordController="";
  @override
  Widget build(BuildContext context) {
    Size mq=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor().backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [CustomColor().darkCode,CustomColor().backgroundColor,CustomColor().darkCode])
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                    height: mq.height * 0.4,
                    width: mq.width,
                    decoration: BoxDecoration(
                        color: CustomColor().appBar,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(mq.height*0.2), bottomRight:Radius.circular(mq.height*0.2))
                    ),
                    child: Container(
                        margin: EdgeInsets.only(top:mq.height*0.3, left: mq.width*0.4),
                        child: Text("Free Vid", style: GoogleFonts.raleway(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),))),
                SizedBox(height: mq.height*0.1,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: CustomColor().appBar,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        hintText: 'eg: xyz@gmail.com',
                        label: const Text('Email', style: TextStyle(color: Colors.black),)),
                    validator: validateEmail,
                    onChanged: (String? value) {
                      usernameController = value!.trim();
                      print(usernameController);
                    },
                  ),
                ),
                SizedBox(height: mq.height*0.02,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          color: CustomColor().appBar,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        label: const Text('Password', style: TextStyle(color: Colors.black),)),
                    validator: validatePassword,
                    onSaved: (String? value) {
                      passwordController = value!.trim();
                    },
                  ),
                ),
                SizedBox(height: mq.height*0.05,),
                ElevatedButton(onPressed: (){
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    usernameController.trim();
                    passwordController.trim();
                    // passwordController="";
                    APIs().loginUser(usernameController,passwordController,context);

                  }

                }, child: const Text('Sign In', style:TextStyle(color: Colors.black),),style: ElevatedButton.styleFrom(backgroundColor: CustomColor().appBar,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)), minimumSize: Size(mq.width*0.8, mq.height*0.06)),),
                SizedBox(height: mq.height*0.02,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(text:"Don't have an account?", style: TextStyle(color: Colors.black)),
                      TextSpan(text:' Sign Up', style: TextStyle(color: Colors.blue), recognizer: TapGestureRecognizer()..onTap=(){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AdminRegister()));
                      }),
                    ]
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
  String? validateEmail(String? value) {
    String val= value!.trim();
    if (val == null || val.isEmpty) {
      return 'Please enter your email address';
    }
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(val)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password should be at least 8 characters';
    }
    if (!value.contains(new RegExp(r'[A-Z]'))) {
      return 'Password should contain at least one uppercase letter';
    }
    if (!value.contains(new RegExp(r'[a-z]'))) {
      return 'Password should contain at least one lowercase letter';
    }
    if (!value.contains(new RegExp(r'[0-9]'))) {
      return 'Password should contain at least one number';
    }
    return null;
  }
}

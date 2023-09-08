import 'package:flutter/material.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/utils/colors.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Profile"),
        backgroundColor: CustomColor().appBar,
      ),
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
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Text("ADMIN EMAIL"),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                initialValue: APIs().user!.email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: CustomColor().appBar)),
                ),
              ),
            ),

        ],),

      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        APIs().signOut(context);
      }, label:const Text("LogOut"), icon: const Icon(Icons.logout),backgroundColor: Colors.red,),
    );

  }
}

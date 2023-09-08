import 'package:flutter/material.dart';
import 'package:freevid/Model/Event_Model.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/provider/mainProvider.dart';
import 'package:freevid/screens/modelAttendance/user_Attendance.dart';
import 'package:freevid/utils/colors.dart';
import 'package:freevid/utils/myDateUtill.dart';
import 'package:provider/provider.dart';
class NavAllEvent extends StatefulWidget {
  final Size mq;
  const NavAllEvent({super.key, required this.mq});

  @override
  State<NavAllEvent> createState() => _NavAllEventState();
}

class _NavAllEventState extends State<NavAllEvent> {
  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider=Provider.of<MainProvider>(context);
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
      child: StreamBuilder(
        stream: APIs().getEventData(),
        builder: (context, snapshot) {
          final list=snapshot.data?.docs??[];
          List<CreateEvents> k=list.map((e) => CreateEvents.fromJson(e.data())).toList();
         switch(snapshot.connectionState){
           case ConnectionState.waiting:
           case ConnectionState.none:
           return const Center(
             child: CircularProgressIndicator(),
           );
           case ConnectionState.active:
           case ConnectionState.done:
             if(list.isNotEmpty){
               return GridView.builder(
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2,
                 ),
                 itemBuilder: (context, index) {
                   return Padding(
                     padding: const EdgeInsets.all(12),
                     child: InkWell(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (_)=>UserAttendance(createEvents: k[index])));
                       },

                       child: GridTile(
                         child: Container(
                           // Placeholder color
                           decoration: BoxDecoration(
                               color: CustomColor().appBar,
                               borderRadius: BorderRadius.circular(22)
                           ),
                           child: Column(
                             children: [
                               SizedBox(height: 8),
                               Image.asset("assets/images/graduates.png",width: 100,),
                               SizedBox(height: 6,),
                               Text(
                                 k[index].EventName,
                                 style: const TextStyle(color: Colors.black87),
                               ),
                               Text("${MyDateUtil.getFormattedStringDate(k[index].Date)}"),
                             ],
                           ),
                         ),
                       ),
                     ),
                   );
                 },
                 itemCount: list.length,
               );
             }

         }
         return SizedBox();
        }
      ),
    );
  }
}

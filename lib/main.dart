import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freevid/api/apis.dart';
import 'package:freevid/provider/mainProvider.dart';
import 'package:freevid/screens/auth/admin_login.dart';
import 'package:freevid/screens/auth/admin_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freevid/screens/homeScreen.dart';
import 'package:freevid/utils/colors.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp());
}


// ...



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<bool?> checkUserLoggeinOrNot() async {
      if(APIs().user!=null){
        return true;
      }else{
        return false;
      }
    }
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (_)=>MainProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          primaryColor: CustomColor().appBar,
          colorScheme: ColorScheme.fromSeed(seedColor: CustomColor().appBar),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: checkUserLoggeinOrNot(),
          builder: (context,snapshot){
            if(snapshot.hasData && snapshot.data==true){
              return const HomeScreen();
            }else{
              return const AdminLogin();
            }
          },
        )
      ),
    );
  }

}


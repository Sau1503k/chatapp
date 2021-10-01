
import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/views/chatscreen.dart';
import 'package:chatapp/views/signin.dart';
import 'package:chatapp/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsloggedIn;
  @override
  void initState() {
    getLoggedInstate();
    super.initState();
  }
  getLoggedInstate()async{
    await HelperFunction.getUserLoggedInsharedpreference().then((val){
      setState(() {
        userIsloggedIn=val;
      });


    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primaryColor: Color(0xff145C9E),

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:userIsloggedIn !=null ? userIsloggedIn ? ChatScreen() : Authenticate():
          Container(
            child: Center(
              child: Authenticate(),
            ),
          )
    );
  }
}


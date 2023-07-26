
import 'package:chatmet/helper/helper.dart';
import 'package:chatmet/pages/homepage.dart';
import 'package:chatmet/pages/login%20page/Loginpage.dart';
import 'package:chatmet/webapp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
  {
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: webapp.apiKey, appId: webapp.appId, messagingSenderId: webapp.messagingSenderId, projectId: webapp.projectId));
  }
  else
  {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSigned = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getUserLoggedInStatus();
  }
  getUserLoggedInStatus()async{
    await helperFunction.getUserLoggedInStatus().then((value){
  if(value!=null) {
    setState(() {
      _isSigned = value;
    });

  }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:webapp.primaryColor,

      ),
      home: _isSigned? const HomePage(): const Loginpage(),
    );
  }
}

import 'package:chatmet/Auth%20Service/authFirebase.dart';
import 'package:chatmet/Auth%20Service/database_service.dart';
import 'package:chatmet/pages/login%20page/registerpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../homepage.dart';
import 'formfeild.dart';
import 'package:chatmet/helper/helper.dart';


class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final formkey = GlobalKey<FormState>();
  String email="";
  String password="";
  bool isLoading=false;
  AuthService authService =AuthService();

  login()async
  {
    if(formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService.LoginUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
         QuerySnapshot snapshot=
         await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
         await helperFunction.saveUserLoggedInStatus(true);
         await helperFunction.saveUserEmail(email);
         await helperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
         nextScreenReplacement(context, const HomePage());
        }
        else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),)
      :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10,vertical: 60),
          child: Form(
            key:formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
             const  Text("CHATMET",
                style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 0,),
                const Text("Login now only for Homies",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                Image.asset("assests/loginpagelogo.png"),
                TextFormField(decoration: textinputdecoration.copyWith(
                  prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,),labelText: "Email",
                ),
                  onChanged: (val){
                  setState(() {
                    email=val;
                  });
                  },
                  validator: (val)
                  {
                    return RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$').hasMatch(val!)
                        ? null
                        : "please enter a valid email";

                  },
                ),
                SizedBox(height: 10,),
                TextFormField(decoration: textinputdecoration.copyWith(
                    prefixIcon: Icon(Icons.lock,color: Theme.of(context).primaryColor,),labelText: "Password"
                ),
                  validator: (val)
                  {
                    if(val!.length <6)
                      {
                          return "Passsword must be at least 6 charecors";
                      }
                    else{
                      return null;
                    }
                  },
                  onChanged: (val){
                  setState(() {
                    password=val;
                  });
                  },
                ),
               SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                    child: const Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 16),),
                    onPressed: (){
                      login();
                  },

                  ),
                ),
                Text.rich(TextSpan(
                  text:"Don't have an account||",
                  style: TextStyle(color: Colors.black,fontSize: 14),
                  children: [
                    TextSpan(
                      text:"Register here",
                      style: TextStyle(color: Colors.blue,fontSize: 14),
                      recognizer: TapGestureRecognizer()..onTap=(){
                        nextScreen(context, const RegisterPage());
                      }
                    )
                  ]
                ))
              ],
            ) ,
          ),
        ),
      ),
    );
  }
}

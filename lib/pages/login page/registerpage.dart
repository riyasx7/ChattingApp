import 'package:chatmet/Auth%20Service/authFirebase.dart';
import 'package:chatmet/helper/helper.dart';
import 'package:chatmet/pages/homepage.dart';
import 'package:chatmet/pages/login%20page/Loginpage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'formfeild.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  bool isLoading =false;
  String email = '';
  String password = '';
  String fullName="";
  AuthService authservice =AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10,vertical: 60),
          child: Form(
            key:formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const  Text("Register",
                  style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 0,),
                const Text("register now for chat with your friends",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                Image.asset("assests/2650152.jpg"),
                TextFormField(decoration: textinputdecoration.copyWith(
                  prefixIcon: Icon(Icons.person,color: Theme.of(context).primaryColor,),labelText: "FullName",
                ),
                  onChanged: (val){
                    setState(() {
                      fullName=val;
                    });
                  },
                  validator: (val)
                  {
                    if(val!.isEmpty)
                      {
                        return "your name feild is empty";
                      }
                    else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10,),
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
                    child: const Text("Register",style: TextStyle(color: Colors.white,fontSize: 16),),
                    onPressed: (){
                      register();
                    },

                  ),
                ),
                Text.rich(TextSpan(
                    text:"already have an account||",
                    style: TextStyle(color: Colors.black,fontSize: 14),
                    children: [
                      TextSpan(
                          text:"Login here",
                          style: TextStyle(color: Colors.blue,fontSize: 14),
                          recognizer: TapGestureRecognizer()..onTap=(){
                            nextScreen(context, const Loginpage());
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
  register()async
  {
    if(formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authservice.registerUserWithEmailandPassword(
          fullName, email, password).then((value) async {

        if (value == true) {
          await helperFunction.saveUserLoggedInStatus(true);
          await helperFunction.saveUserEmail(email);
          await helperFunction.saveUserNameSF(fullName);
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
}

import 'package:chatmet/Auth%20Service/authFirebase.dart';
import 'package:chatmet/pages/homepage.dart';
import 'package:flutter/material.dart';

import 'login page/Loginpage.dart';
import 'login page/formfeild.dart';
class profilePage extends StatefulWidget {
  String userName;
  String email;
   profilePage({super.key, required String this.userName, required String this.email});
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  AuthService authService=AuthService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        title:  Text(
          "profile",style: TextStyle
          ( color: Colors.white,fontSize: 27,fontWeight: FontWeight.bold),
      ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,size: 150,
              color: Colors.grey,),
            const SizedBox(height: 15,),
            Text(widget.userName,textAlign:TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold ),),
            ListTile(
              onTap: (){
                nextScreenReplacement(context, HomePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: ()async{

              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Profile",style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: ()async{
                showDialog(context: context, barrierDismissible:true,builder:(context) {
                  return AlertDialog(
                    title: const Text("LOG OUT"),
                    content: Text("Are you sure do you want to log out"),
                    actions: [
                      IconButton(onPressed:(){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.cancel,color: Colors.red,)),
                      IconButton(onPressed:(){
                        authService.signout();
                        nextScreenReplacement(context, Loginpage());
                      }, icon: Icon(Icons.done,color: Colors.green,)),

                    ],
                  );
                });
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Logout",style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50,vertical: 170),
        child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.account_circle,size: 200,color: Colors.grey,),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text("User Name :"),
                  Text(widget.userName),

                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text("User Email :"),
                  Text(widget.email!),

                ],
              )
            ],
      ),
      ),
    );
  }
}

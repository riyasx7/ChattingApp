import 'package:chatmet/Auth%20Service/authFirebase.dart';
import 'package:chatmet/Auth%20Service/database_service.dart';
import 'package:chatmet/pages/group_tile.dart';
import 'package:chatmet/helper/helper.dart';
import 'package:chatmet/pages/SearchPage.dart';
import 'package:chatmet/pages/login%20page/Loginpage.dart';
import 'package:chatmet/pages/login%20page/formfeild.dart';
import 'package:chatmet/pages/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName="";
  String email="";
  Stream? groups;
  String groupName="";
  String admin="";
  String groupID="";
  bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();

  }

  String getId(String res)
  {
    return res.substring(0,res.indexOf("_"));
  }
  String getName(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }
  gettingUserData()async
  {
    await helperFunction.getUserEmailStatus().then((value) {
      setState(() {
        email =value!;
      });
    });
    await helperFunction.getUserNameStatus().then((value) {
      setState(() {
        userName =value!;
      });
    });
    await DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).getUserGroups()
    .then((snapshot){
      setState(() {
        groups=snapshot;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(onPressed: (){
                nextScreen(context, searchpage());
              }, icon: const Icon(Icons.search))
            ],
            elevation: 5,
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text("Groups",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
          ),
         drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: [
                  Icon(Icons.account_circle,size: 150,
                  color: Colors.grey,),
                    const SizedBox(height: 15,),
                 Text(userName,textAlign:TextAlign.center,
                 style: const TextStyle(fontWeight: FontWeight.bold ),),
              ListTile(
                onTap: (){},
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
                onTap: (){
                  nextScreen(context, profilePage(userName:userName,email:email));
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
         body: groupList(),
         floatingActionButton: FloatingActionButton(
           onPressed: (){
              popUpDialog(context);
           },
           elevation: 0,
           child: Icon(Icons.add,size: 30,),
           backgroundColor :Theme.of(context).primaryColor,
         ),
    );
  }
  popUpDialog(BuildContext context)
  {

     showDialog(context: context,barrierDismissible: true, builder: (context)
     {

      return AlertDialog(
        title: const Text("create a group",textAlign: TextAlign.left,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading==true?Center(child: CircularProgressIndicator(color:
              Theme.of(context).primaryColor,),):
                TextField(
                        onChanged: (val){
                          setState(() {
                            groupName=val;
                          });
                        },

                    decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

          ],
        ),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("cancel"),style:ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor

          ),),
          ElevatedButton(onPressed: (){

            if(groupName!="")
              {
                setState(() {
                  isLoading=true;
                });
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName,FirebaseAuth.instance.currentUser!.uid,groupName).whenComplete(() {
                  isLoading=false;
                }
                );
                Navigator.of(context).pop();
                showSnackbar(context, Colors.green, "Group created successfully");
              }
          }, child: Text("create"),style:ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor

          ),)
        ],
      );
     });
  }
 Widget groupList()
  {
    return StreamBuilder(
      stream: groups,
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData)
          {
              if(snapshot.data['groups']!=null)
                {
                    if(snapshot.data['groups'].length!=0)
                      {
                          return ListView.builder(
                            itemCount: snapshot.data['groups'].length,
                              itemBuilder: (context,index){
                              int reverseIndex=snapshot.data['groups'].length-index-1; //5-0-1=4

                                return groupTile(userName: snapshot.data['fullName'] , groupId: getId(snapshot.data['groups'][reverseIndex]), groupName: getName(snapshot.data['groups'][reverseIndex]));
                              });
                      }
                    else{
                      return noGroupWidget();
                    }
                }
              else{
                return noGroupWidget();
              }
          }
        else{
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
 Widget noGroupWidget()
  {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: (){
                popUpDialog(context);
              },
              child: Icon(Icons.add_circle,color: Colors.grey,size: 75,)),
          const SizedBox(height: 20,),
          Text("You've not joined any groups,tap on the add icon to create a group or also search from top serach button.",textAlign: TextAlign.center,),
        ],
      ),
    );
  }

}

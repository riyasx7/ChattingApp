import 'package:chatmet/Auth%20Service/database_service.dart';
import 'package:chatmet/helper/helper.dart';
import 'package:chatmet/pages/chatPage.dart';
import 'package:chatmet/pages/group_tile.dart';
import 'package:chatmet/pages/login%20page/formfeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  TextEditingController searchController =TextEditingController();
  bool _isLoading=false;
  QuerySnapshot? searchSnapsot ;
  bool hasUserSearched = false;
  String userName="";
  User? user;
  bool isJoined=false;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserIdName();

    super.initState();
  }
  String name(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }
  String id(String res)
  {
    return res.substring(0,res.indexOf("_"));
  }
  getCurrentUserIdName()async
  {
    await helperFunction.getUserNameStatus().then((value)
    {
      setState(() {
        userName =value!;
      });
    });
    user =FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search",
        style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:Center(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: searchController,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups",
                      hintStyle:TextStyle(color: Colors.white,fontSize: 16)
                    ),
                  )),
                  GestureDetector(
                    onTap: (){
                      initiateSearchMethod();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius:  BorderRadius.circular(40),

                      ) ,
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            _isLoading ? Center(child:CircularProgressIndicator(color: Theme.of(context).primaryColor),)
                :groupList(),
          ],
        ),
      ),
    );
  }
  initiateSearchMethod()async
  {
    if(searchController.text.isNotEmpty)
      {
        setState(() {
          _isLoading = true;
        });
        await DatabaseService().searchByName(searchController.text)
        .then((snapshot)
            {
              setState(() {
                  searchSnapsot=snapshot;
                  _isLoading=false;
                  hasUserSearched=true;
              });
            }
        );
      }
  }
  groupList(){
      return hasUserSearched ? ListView.builder(
           shrinkWrap: true,
          itemCount: searchSnapsot!.docs.length,
          itemBuilder: (context,index)
            {
              return groupTile(
                userName,
                searchSnapsot!.docs[index]['groupId'],
                searchSnapsot!.docs[index]['groupName'],
                searchSnapsot!.docs[index]['admin']


              );
            }):Container();
  }
  joinedOrNot(String userName,String groupId,String groupName,String admin)async
  {
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value)
    {
      setState(() {
        isJoined=value;
      });
    });
  }
  Widget groupTile(
      String userName,String groupId,String groupName,String admin)
        {
        joinedOrNot(userName,groupId,groupName,admin);
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Text(groupName.substring(0,1).toUpperCase(),style: TextStyle(color: Colors.white),),
            ),
            title: Text(groupName,style: TextStyle(fontWeight:FontWeight.bold),),
            subtitle: Text("Admin : ${name(admin)}"),
            trailing: InkWell(
              onTap: ()async{
                await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
                if(isJoined) {
                  setState(() {
                    isJoined = !isJoined;
                  });
                  showSnackbar(context, Colors.green, "Successfully joined");
                  Future.delayed(const Duration(seconds:2 ));
                  nextScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
                }
                else{
                  setState(() {
                    isJoined =!isJoined;
                  });
                  showSnackbar(context, Colors.red, "You lefted the group");
                }
              },
              child: isJoined?Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                  border: Border.all(),
                ),
                padding: EdgeInsets.symmetric(horizontal:5,vertical: 2),
                child: Text("Joined",style: TextStyle(color: Colors.white),),
              ):Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                  border: Border.all(),
                    ),
                  padding: EdgeInsets.symmetric(horizontal:5,vertical: 2),
                   child: Text("Join Now",style: TextStyle(color: Colors.white),
              ),
            ),
            ),
          );
  }
}

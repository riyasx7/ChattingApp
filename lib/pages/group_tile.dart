import 'package:chatmet/pages/chatPage.dart';
import 'package:chatmet/pages/login%20page/formfeild.dart';
import 'package:flutter/material.dart';
class groupTile extends StatefulWidget {
  const groupTile({super.key, required this.userName, required this.groupId, required this.groupName});
  final String userName;
  final String groupId;
  final String groupName;

  @override
  State<groupTile> createState() => _groupTileState();
}

class _groupTileState extends State<groupTile> {
  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: (){
       nextScreen(context,ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName));
     },
     child: Container(
       padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          ),
          title: Text(widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join with conversation ${widget.userName}",style: TextStyle(fontSize: 13),),
        ),

     ),
   );
  }
}

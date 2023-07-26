import 'package:flutter/material.dart';
const textinputdecoration=InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
     borderSide: BorderSide(color: Color.fromRGBO(255, 150, 143,10),width: 2,)
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(32, 149, 195, 0.8),width: 2)
  ),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(218, 24, 24, 0.8),width: 2)
  ),

);
void nextScreen(context,page)
{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
}
void nextScreenReplacement(context,page)
{
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
}
void showSnackbar(context,color,message)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style: const TextStyle(fontSize: 20),
  ),
  backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(label:"ok" ,onPressed: (){},textColor: Colors.white),
  ));
}
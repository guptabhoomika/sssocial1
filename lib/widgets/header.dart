import 'package:flutter/material.dart';
AppBar header(context,{bool isAppTitle = false,String titleText}){
  return AppBar(
    automaticallyImplyLeading: false,
    title:   Text(
      isAppTitle ?
      "Wiringbridge" : titleText,
    style: TextStyle(
      color: Colors.white,
       fontFamily:  isAppTitle ?"Signatra" : "",
      fontSize: isAppTitle ? 50 : 22.0
    ),),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
   
  );
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sssocial/pages/authpage.dart';
import 'package:sssocial/pages/unauthpage.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    check();
    super.initState();
  }
  check() async
{
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getBool("isauth"));
  if(prefs.getBool("isauth")==true)
  {
  
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Auth()));
  }
  else
  {
    print("in else");
    
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>UnAuth()));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}
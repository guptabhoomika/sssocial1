import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sssocial/pages/home.dart';




void main(){
 runApp(new MaterialApp(
   home:new Myapp()
 ));
}
class Myapp extends StatefulWidget{
@override
_State createState() => new _State();
}

class _State extends State<Myapp>{




@override

  Widget  build(BuildContext context){
// _getData(r);
    return  MaterialApp(
      title:'Scrapshut',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
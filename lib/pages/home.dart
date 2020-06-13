import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/unauthpage.dart';
import '../pages/authpage.dart';
import 'package:sssocial/pages/ActivityFeed.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sssocial/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:sssocial/pages/search.dart';
import 'package:sssocial/pages/upload.dart';
import 'package:sssocial/pages/userprofile.dart';
// import fit_image;
import 'timeline.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class Methods
{
 static final storage = new FlutterSecureStorage();
static final String auth="https://backend.scrapshut.com/a/google/";



static final googlesignin= GoogleSignIn();

 


String token ='';
String value='';
String gtoken='';





  static login(BuildContext context) async  {
  googlesignin.signIn().then((result){
        result.authentication.then((googleKey) async {
          var gtoken = googleKey.accessToken;
          // print(gtoken);
          await storage.write(key: 'token', value: gtoken);
          String value = await storage.read(key: 'token');
          print(value);
          print("sucess post");
     
          Map<String,String> headers = {'Content-Type':'application/json'};
          final msg = jsonEncode({"token":"$value"});
          print(msg);

          var response = await http.post(auth ,body:msg,

          headers: headers

          );
 if(response.statusCode == 200) {
    //                 Navigator.of(context).push(PageRouteBuilder(
    // opaque: false,
    // pageBuilder: (BuildContext context, _, __) =>
    //     SomeDialog()));
    
                    print("tap");
                  //check();

                   
  
      String responseBody = response.body;
      print(responseBody);
     Map<String, dynamic> responseJson = jsonDecode(response.body);
     String btoken=responseJson['access_token'];
      await storage.write(key: 'btoken', value: btoken);
      String bvalue = await storage.read(key: 'btoken');
      print(bvalue);
      print("sucess");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isauth", true);
      print(prefs.getBool("isauth"));
      // setState(() {
      //   this.context = context;
      // });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Auth()));
  
    }
   else{
     print("not success");
   } 
  
          });
  });
}

static logout(BuildContext context) async {
    try {
      //await _fireBaseAuthInstance.signOut();
      await  googlesignin.disconnect();
      await googlesignin.signOut();
    } catch (e) {
      print('Failed to signOut' + e.toString());
    }
   SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isauth", false);
       Navigator.push(context, MaterialPageRoute(builder: (context)=>UnAuth()));



}


}

  

class SomeDialog extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black.withOpacity(0.75),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.75) ,
      ),
      
      body: Center(child: Text("It's a dialog",style: TextStyle(color: Colors.white),)),
    );
  }
}
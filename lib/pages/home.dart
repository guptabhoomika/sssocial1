import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sssocial/pages/home.dart';
import 'package:flutter/cupertino.dart';
// import fit_image;

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
String auth="https://backend.scrapshut.com/a/google/";



final googlesignin= GoogleSignIn();
class Home extends StatefulWidget{
@override
_HomeState createState() =>  _HomeState();
}

// class _HomeState {
// }

class _HomeState extends State<Home>{
bool isAuth =false;
String token ='';
String value='';
String gtoken='';
@override
void initState(){
super.initState();
googlesignin.onCurrentUserChanged.listen((account){
if (account != null){
  print("user signed in ");
  setState(() {
    
    isAuth=true;
  });
}
else{
  setState(() {
    
    isAuth=false;
  });
}
},onError:(err){
  print("eror signing in $err");
});
googlesignin.signInSilently(suppressErrors:false)
.then((account){
  if (account != null){
  print("user signed in with mounikesh");
  setState(() {
    
    isAuth=true;
  });
}
else{
  setState(() {
    
    isAuth=false;
  });
}
});
}
 login()  {
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
      String responseBody = response.body;
      print(responseBody);
     Map<String, dynamic> responseJson = jsonDecode(response.body);
     String btoken=responseJson['access_token'];
      await storage.write(key: 'btoken', value: btoken);
      String bvalue = await storage.read(key: 'btoken');
      print(bvalue);
      print("sucess");
    }
   else{
     print("not success");
   } 
          });
  });
}
logout(){
    googlesignin.signOut();

   storage.delete(key: 'btoken');
   storage.delete(key: 'token');


    
}
Widget buildAuthScreen(){
return RaisedButton(
  child: Text("Logout") ,
  onPressed: logout
); 
}
 Scaffold buildUnAuthScreen(){
 return Scaffold(
body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin:Alignment.topRight,
      end:Alignment.bottomLeft, colors: <Color>[
        Colors.teal,
        Colors.purple,
      ],
        ),
  ),
alignment: Alignment.center,
  child:Column(
      mainAxisAlignment:MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

    children: <Widget>[
    Text("Scrapshut",style:TextStyle(
      fontFamily:"Signatra",
       fontSize:40.0,
       color:Colors.lightBlue,
       ),
       ),
       GestureDetector(
         onTap: login(),
         child: Container(
           width:350.0,
           height:60.0,
           decoration:BoxDecoration(
             image:DecorationImage(image: AssetImage('assets/images/download.png'),
             fit : BoxFit.cover,
              ),
           ),   
         ),
       ),


  ],),
),
 );
}
@override

  Widget  build(BuildContext context){
    // return Text("home");
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
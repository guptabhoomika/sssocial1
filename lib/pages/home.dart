import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
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
PageController _pageController;
int pageIndex = 0;
@override
void initState(){
super.initState();
_pageController = PageController();

}
@override
void dispose()
 {
   _pageController.dispose();
   super.dispose();

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
    setState(() {
     isAuth = true;
   });
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

Future logout() async {
    try {
      //await _fireBaseAuthInstance.signOut();
      await  googlesignin.disconnect();
      await googlesignin.signOut();
    } catch (e) {
      print('Failed to signOut' + e.toString());
    }
   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}
onPageCahnged(int index)
{
  setState(() {
    pageIndex = index;
  });
}
ontap(int index)
{
  _pageController.animateToPage(
    index,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut
    );
}
Scaffold buildAuthScreen(){
  return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLine(),
          // ActivityFeed(),
          // Upload(),
          // Search(),
          UserProfile()


        ],
        controller: _pageController,
        onPageChanged: onPageCahnged,
        physics: NeverScrollableScrollPhysics(),
        
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: ontap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          // BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          // BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size:35.0)),
          // BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
  );
// return RaisedButton(
//   child: Text("Logout") ,
//   onPressed: logout
// ); 
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
      Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/wiringbridge.png",),fit: BoxFit.cover),
          
        ),

      ),
      SizedBox(height: 20,),
    Text("Wiringbridge",style:TextStyle(
      fontFamily:"Signatra",
       fontSize:40.0,
       color:Colors.lightBlue,
       ),
       ),
       SizedBox(height: 20,),
       RaisedButton(
         onPressed:(){
           print("Tap");
           login();

         } ,
         child: Container(
          
           height:60.0,
           decoration:BoxDecoration(
             color: Colors.red,
             image:DecorationImage(image: AssetImage('assets/images/download.png'),
             fit : BoxFit.fill,
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
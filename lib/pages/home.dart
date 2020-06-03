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
          print(response.statusCode);
 if(response.statusCode == 200) {
   
      String responseBody = response.body;
      print(responseBody);
     Map<String, dynamic> responseJson = jsonDecode(response.body);
     String btoken=responseJson['access_token'];
      await storage.write(key: 'btoken', value: btoken);
      String bvalue = await storage.read(key: 'btoken');
      print(bvalue);
      print("sucess");
      setState(() {
        isAuth = true;
      });
      //to the full screen dialog
       Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) =>
        SomeDialog()));
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
  print("f1");
 
    print("f2");
  _pageController.animateToPage(
    index,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut
    );
}
Scaffold buildAuthScreen(){
  return 
  Scaffold(
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
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/wiringbridge.png"))
                ),
              ),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    

 );
}
Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        print("Tap");
        login();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
@override

  Widget  build(BuildContext context){
    // return Text("home");
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
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
      
      body: Center(child: new Text("It's a Dialog!",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
    );
  }
}
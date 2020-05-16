import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sssocial/pages/home.dart';
import 'package:sssocial/widgets/header.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}
 List<dynamic> results;
 List<dynamic> _tags;
 String coins;
 bool havData = false;

class _UserProfileState extends State<UserProfile> {
  _makeGetRequest() async {
    String bvalue = await storage.read(key: 'btoken');
  // make GET request
  String url = 'https://backend.scrapshut.com/user/profile/';
   Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json"};


  http.Response response = await http.get(url,headers: headers);
  // sample info available in response
  int statusCode = response.statusCode;
  print(statusCode);
  print(response.body);
  Map<String,dynamic> val =jsonDecode(response.body);
  setState(() {
     results = val['results'];
  });
  setState(() {
    _tags = results[0]["tags"];
  });
  setState(() {
    coins = results[0]["Scrapcoins"].toString();
  });
 setState(() {
   havData = true;
 });
  }
  @override
  void initState() {
    // TODO: implement initState
    _tags = new List<dynamic>();
    _makeGetRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
    
      body: SingleChildScrollView(
              child: havData == false ? Container() :
              Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomSClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: 
                      [
                        Colors.blue,
                        Colors.deepPurple
                      ],
                    


                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 100),
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          
                          Text("Hey!",style: TextStyle(color: Colors.white,fontSize: 20),),
                          SizedBox(width: 60,),
                          Text(results[0]["username"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
                             
                             Container(height: 75,),
                            Row(
                              children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(coins,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
                                 Text("Scrapcoins",style: TextStyle(color: Colors.white,fontSize: 20),),

                                ],
                                
                              ),
                                Container(width: 100,),
                              Column(
                                children: <Widget>[
                                  Text(results[0]["Licenced"].toString().toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
                                 Text("Licenced",style: TextStyle(color: Colors.white,fontSize: 20),),

                                ],
                              )

                            ],),
                            Container(height: 50,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 95,vertical: 10),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Text("Your Tags:",style: TextStyle(color: Colors.white,fontSize: 20)),
                                    ListView.builder(
                                      itemCount: _tags.length,
                                      
                                        physics: NeverScrollableScrollPhysics(),
                                       shrinkWrap: true,
                                      itemBuilder: (context,index){
                                        return 
                                           Text( "     " + _tags[index].toString().toUpperCase() + " ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15));
                                        
                                    
                                      },
                                    )

                                    
                                  ],
                                ),
                              ),
                            )
                           
                             
                             


                        ],
                      ),
                    ),
                    
                  ),
                )

              ],
            ),
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 250),
            child: 
            Text("SIGNOUT",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 20),),
          )
             
            
          ],
        ),
      )
    );
  }
  
}
class CustomSClipper extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    final Path path = new Path();
    path.lineTo(0, size.height);
    var firstEndPoint = Offset(size.width * 0.4,size.height-30);
    var firstControlpoint = Offset(size.width *0.20,size.height-50);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,firstEndPoint.dx, firstControlpoint.dy);
    var secondEndPoint = Offset(size.width, size.height - 75.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sssocial/pages/home.dart';
import 'package:sssocial/widgets/header.dart';
import 'package:http/http.dart' as http;
import 'package:sssocial/widgets/image.dart';
import 'package:sssocial/widgets/imageprof.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}
 List<dynamic> results = List();
 List<dynamic> _tags = List();
 String coins;
 bool data =false; //to show cicular indicatore til data is fetched
 bool urldata = false;
 bool msgdata = false;

 

class _UserProfileState extends State<UserProfile> with SingleTickerProviderStateMixin {
  List<Tab> _listTab = List();
  _makeGetRequest() async {
    setState(() {
      data = false;
    });
    String bvalue = await Methods.storage.read(key: 'btoken');
  // make GET request
  String url = 'https://backend.scrapshut.com/user/profile/';
   Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};


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
      data = true;
    });
  }
  Map<String,dynamic> _data;//stores response of get request from post endpoint
Map<String,dynamic> _msgdata;//stores response of get request from msg endpoint
List<dynamic> _msgresults; //stores the list of result of msg
List<dynamic> _results; //stores the list of result of url
  _getTabResponse() //geturlresponse
  async {
    setState(() {
      urldata = false;
    });
     String bvalue = await Methods.storage.read(key: 'btoken');
  // make GET request
  String url = 'https://backend.scrapshut.com/user/post/';
     Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
          http.Response response = await http.get(url,headers: headers);
          print("url");
          print(response.body);
          print(response.statusCode);
          _data =  jsonDecode(response.body);
    print(_data);
    setState(() {
      _results = _data['results'];
    });
    print(_results.length);
    setState(() {
      urldata = true;
    });

  }
  _getResponseMsg() async{ 
    //getmsgresponse
    setState(() {
      msgdata = false;
    });
    String bvalue = await Methods.storage.read(key: 'btoken');
    Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
          String url = "https://backend.scrapshut.com/user/message/";
    http.Response response = await http.get(url,headers: headers);
    print("msg");
     print(response.statusCode);
    print(response.body);
   
    _msgdata = jsonDecode(response.body);
    print(_msgdata);
    setState(() {
      _msgresults = _msgdata['results'];
    });
    print("Message");

   setState(() {
     msgdata = true;
   });
    print(_msgresults.length);
  }
  Future<http.Response> delete(int id) async {
     String bvalue = await Methods.storage.read(key: 'btoken');
    print("in delete");
    print(id);
    Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
          print(headers);
          final http.Response response = await http.delete(
    'https://backend.scrapshut.com/user/post/$id',
    headers:  headers
    
  );
  
   Navigator.of(context, rootNavigator: true).pop();
  print("delete");
  //var r =  jsonDecode(response.body);
  //print(r);
  print(response.statusCode);
 
  // print("making get req again");
  _getTabResponse();
  
  
  return response;
}
 

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _listTab.add(new Tab(text: "URL",));
    _listTab.add(new Tab(text:"Message"));
    _listTab.add(new Tab(text: "Image",));
    _tabController = new TabController(length: _listTab.length, vsync: this); //tabcontrollerinitalized
    _tags = new List<dynamic>();
    _getResponseMsg();
    _getTabResponse();
   // _getResponseImg();
    _makeGetRequest();
   
     
    
    print("done");
 
    super.initState();
  }
  
  @override
  Widget build(BuildContext context)  {

    return  data == false && urldata == false && msgdata == false ? Center(child: CircularProgressIndicator(),) :
    Scaffold(
      
      appBar: header(context,isAppTitle: false,titleText: "Profile"),
    
      body:  
      SingleChildScrollView(
              child: Column(
          children: <Widget>[
             SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Username: ",style: TextStyle(fontSize: 15),),
                  Text(results[0]["username"],style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("ScrapCoins: ",style: TextStyle(fontSize: 15)),
                  Text(coins,style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Licenced: ",style: TextStyle(fontSize: 15)),
              Text(results[0]["Licenced"].toString().toUpperCase(),style: TextStyle(fontSize: 15))

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Text("Tags: ",style: TextStyle(fontSize: 15)),
               Text(_tags.toString().replaceAll("[", "").replaceAll("]", ""),style: TextStyle(fontSize: 15))
              
                
                
              ],),
            ),
            RaisedButton(
              child: Text("LOGOUT"),
              onPressed: (){Methods.logout(context);},
            ),
            
            SizedBox(height: 20,),
            Divider(),
            Container(
              height:30,
              
            child: new TabBar(
              controller: _tabController,
              tabs: _listTab,
              indicatorColor: Colors.black,
              labelColor: Colors.blue,
              
            )
            ),
           _results!=null && _msgresults!=null ? Container(
              height:  MediaQuery.of(context).size.height * 0.60,
              child: TabBarView(
                controller: _tabController,
                children: 
                //display method is called to show the response in given ui
                <Widget>[
                   ListView.builder(
          itemCount: _results.length,
          itemBuilder: (context,index){
            return display(_results[index]['rate'], _results[index]['author'], _results[index]['url'], _results[index]["created_at"],  _results[index]['content'], _results[index]['tags'],false,_results[index]["id"]);
          },
         ),
        //Text("url"),
                   ListView.builder(
        itemCount: _msgresults.length,
        itemBuilder: (context,index){
          return display(_msgresults[index]['rate'], _msgresults[index]['author'], _msgresults[index]['review'], _msgresults[index]["created_at"],  _msgresults[index]['content'], _msgresults[index]['tags'],true,_msgresults[index]["id"]);
        },
      ),
                  //Text("ms"),
                  //corrosponds to images file in widgets folder
                    ImagesProf()
                ],
              ),
            ) : Container()


    
            

          ],
        ),
      )
    );
  }

  InkWell display(int rate,String author,String url,String time,String content,List tags,bool isMsg,int id)
  
  {
  String c = time.substring(0,10);
    return InkWell(
      onLongPress: (){
            print("Preess");
        showAlertDialog(context,id,isMsg);
      
      },
          child: Container(
        margin: EdgeInsets.all(8),
        height: 120,
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              color: Colors.grey[300],
              
              
              child: Column(
                children: <Widget>[
                  Text(""),
                    Container(

                                    height:30,
                                    width: 35,
                                     decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/stop.png",)),
          
        ),
                    ),
                  SizedBox(height: 5,),
                  Text(rate.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                   Container(

                                    height:30,
                                    width: 35,
                                     decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/ok.png",)),
          
        ),
                   ),
                ],
              ),
              
            ),
            SizedBox(width: 10,),
            Container(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Row(
                   children: <Widget>[
                    
                     tags.isNotEmpty ?  Text( "Tags: "+ tags.toString().replaceAll("[", " ").replaceAll("]", " " ),style: TextStyle(color: Colors.grey,fontSize: 10 )): Text("No tags ",style: TextStyle(color: Colors.grey,fontSize: 10 )),
                     Text("Author ",style: TextStyle(color: Colors.grey,fontSize: 10),),
                     Text(author + " ",style: TextStyle(color: Colors.grey,fontSize: 10)),
                     Text( "on " + c ,style: TextStyle(color: Colors.grey,fontSize: 7)),
                     
                     
                
                    
                     //Spacer(),
                   ],
                 ),
                 SizedBox(height: 10,),
                 Text(content,style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                   
                 SizedBox(height: 5,),
                
                 
                 Row(
                   children: <Widget>[
                    Text( isMsg==true ? url : url.substring(0,10),style: TextStyle(color: Colors.blue,fontSize: isMsg? 15 : 10 ),),
                   isMsg==true? Text(" ") : Icon(Icons.call_made,color: Colors.blue,size: 10,)

                 ],),
                
                 Spacer(),
                 Row(
                   children: <Widget>[
                     Icon(Icons.message,color: Colors.grey,),
                     SizedBox(width: 5,),
                     Text("Advertisement",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                     
                   ],
                 )

               ],

              )
            )
          ],
        ),
      ),
    );

  }
  showAlertDialog(BuildContext context,int id,bool msg) {  
  // Create button  
  
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {
      if(msg==false)
      {
           delete(id);
      }
      else
      {
        print("Tap");
      }
   
    },
  );
   Widget cancel = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Delete item?"),  
       actions: [  
         cancel,
     continueButton  

    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
}
 
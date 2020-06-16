import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sssocial/pages/home.dart';
import 'package:sssocial/widgets/header.dart';
import 'package:http/http.dart' as http;

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
            // RaisedButton(
            //   color: Colors.red,
            //   child: Text("LOGOUT",style: TextStyle(color: Colors.white),),
            //   onPressed: (){Methods.logout(context);},
            // ),
            
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
            return 
             DisplayP(
              rate: _results[index]['rate'] ?? 0, 
              author: _results[index]['author'] ?? "null",
              url:  _results[index]['url'] ?? "12345678910", 
              time: _results[index]["created_at"] , 
              content:  _results[index]['content'] ?? "nulll", 
              tags: _results[index]['tags'],
              isMsg: false,
              index: index,
              map: _results[index]["advertisement"] ?? null,
             
              );
          },
         ),
        //Text("url"),
                   ListView.builder(
        itemCount: _msgresults.length,
        itemBuilder: (context,index){
          return DisplayP(
           rate: _msgresults[index]["rate"] ?? 0,
           author: _msgresults[index]['author'] ?? "null",
           content: _msgresults[index]['content'] ?? "null",
           isMsg: true,
           index: index,
           map: null,
           tags: _msgresults[index]['tags'] ,
           time: _msgresults[index]["created_at"] ,
           url: _msgresults[index]['review'] ?? "12345678910",
           
         );
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
class DisplayP extends StatefulWidget {
  
  final int rate;
  final String author;
  final String url;
  final String time;
  final String content;
  final List tags;
  final bool isMsg;
  final int index;
  final Map<String,dynamic> map;

  DisplayP({this.rate,this.author,this.url,this.time,this.content,this.tags,this.isMsg,this.index,this.map});
  @override
  _DisplayPState createState() => _DisplayPState();
}

class _DisplayPState extends State<DisplayP> {
  Map<String,dynamic> res = Map();
  Map<String,dynamic> resd = Map();

   bool isexp = false;
  @override
  Widget build(BuildContext context) {
   
    onchange(bool val)
    {
      setState(() {
        isexp = !isexp;
      });
      print(isexp.toString() +  " " + widget.index.toString());
      print(widget.map);
    }
    
    //print(widget.pid);
  String c = widget.time.substring(0,10);
    
    return 
  AnimatedContainer(
    

      height: isexp==true ?250 : 140,
     
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.all(8),
      
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            color: Colors.grey[300],
            
            
            child: Column(
              children: <Widget>[
                Text(""),
                //Icon(Icons.arrow_upward,),
                GestureDetector(
                  onTap: (){
                    print('Ok');
                   
                  },
                                  child: Container(

                                      height:30,
                                      width: 35,
                                       decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/ok.png",)),
          
        ),
                                    ),
                ),
                SizedBox(height: 10,),
                Text(widget.rate.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                   GestureDetector(
                     onTap: (){
                       print("Stop");
                      
                     },
                                        child: Container(
                                      height:30,
                                      width: 35,
                                       decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/stop.png",)),
          
        ),
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
                   //Icon(Icons.blur_circular,color: Colors.blue,),
                   widget.tags.isNotEmpty ?  Text( "Tags: "+ widget.tags.toString().replaceAll("[", " ").replaceAll("]", " " ),style: TextStyle(color: Colors.black,fontSize: 10 )): Text("No tags ",style: TextStyle(color: Colors.grey,fontSize: 10 )),
                   Text("Author ",style: TextStyle(color: Colors.grey,fontSize: 10),),
                   Text(widget.author + " ",style: TextStyle(color: Colors.grey,fontSize: 10)),
                   Text( "on " + c ,style: TextStyle(color: Colors.grey,fontSize: 7)),
                   
                   
              
                  
                   //Spacer(),
                 ],
               ),
               SizedBox(height: 10,),
               Text(widget.content,style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                 
          
               
               Row(
                 children: <Widget>[
                  Text( widget.isMsg==true ? widget.url : widget.url.substring(0,10),style: TextStyle(color: Colors.blue,fontSize: widget.isMsg? 15 : 10 ),),
                 widget.isMsg==true? Text(" ") : Icon(Icons.call_made,color: Colors.blue,size: 10,)

               ],),
              
            // Row(
            //   children: <Widget>[
            //     Text("aa"),
                
                

            //   ],
            // )
            SizedBox(height: 5,),
            AnimatedContainer(
              
              height: isexp == true? 160 : 60,
              duration: Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width * .80,
              
                              child:  widget.map!=null ? ExpansionTile(
                  title: Row(
                  children: <Widget>[
                    Icon(Icons.message,color: Colors.grey,),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text("Advertisement",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
                trailing: Container(height: 2,width: 2,),
                onExpansionChanged: onchange,
                children: <Widget>[
                 widget.map!=null ?  Container(
                   alignment: Alignment.topLeft,
                  
                   child: Column(
                                 //mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 
                                 children: <Widget>[
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: widget.map["title"]!= null ?
                                     Text("Title: " +widget.map["title"],style:TextStyle(fontWeight: FontWeight.bold),) : Container()
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: widget.map["url"]!=null ?
                                     Text("URL: "+widget.map["url"],style:TextStyle(fontWeight: FontWeight.bold)) : Container(),
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: widget.map["advertizing_content"]!=null ?
                                     Text("Content: " +widget.map["advertizing_content"],style:TextStyle(fontWeight: FontWeight.bold)) : Container(),
                                   )
                                 ],
                               ),
                 ) : Container()

                ],
                ) : Container()
                
            )
              

             ],
             

            )
          )
        ],
      ),
    );


    
  }
}

 
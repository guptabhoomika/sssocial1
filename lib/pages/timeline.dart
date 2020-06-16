import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sssocial/pages/home.dart';
import 'package:sssocial/pages/home.dart';

import 'package:sssocial/widgets/header.dart';
import 'package:sssocial/widgets/image.dart';
import 'package:sssocial/widgets/progress.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'home.dart';
class TimeLine extends StatefulWidget {
  
   

  @override
  _TimeLineState createState() => _TimeLineState();
}
Map<String,dynamic> _data;//stores response of get request from post endpoint
Map<String,dynamic> _msgdata;//stores response of get request from msg endpoint
List<dynamic> _msgresults; //stores the list of result of url
List<dynamic> _results; //stores the list of result of msg
 TabController _tabController;
 Map<String,dynamic> _advertisementdata;
 
bool isfetching = true; //to show circular loader while data is being fetched
bool isFetchingmsg = true;
int perPageURL  = 10; //count of url shown in one page
int presentURL = 10; //indexing start from 10
List<dynamic> urlitems = List<dynamic>(); //temporary list to store url of a page
int perPagemsg  = 10; //count of msg shown in one page
int presentmsg = 10; //indexing start from 10
List<dynamic> msgitems = List<dynamic>(); //temporary list to store umsg of a page






class _TimeLineState extends State<TimeLine>  with SingleTickerProviderStateMixin{
 
  //url get request
  _getResponse() async //url get request
  {
    setState(() {
      isfetching = true;
    });
    
    print("url");
     Map<String, String> headers = {"API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
    http.Response _response = await http.get("https://backend.scrapshut.com/api/post/",headers: headers);
    
    //print(_response.body);
    _data =  jsonDecode(_response.body);
    
    

    //print("urlresopnse after decode");
    print(_data);
    setState(() {
      _results = _data['results'];
    });
    //print("url");
    //print(_results.length);
     //setting is fetching false to display data
   //_advertisementdata =  _results[2]["advertisement"];
   print(_advertisementdata);
    setState(() {
      isfetching = false;
    });
    if(_results.length>10)
    {
      //adds initial 10 urls to list
    setState(() {
      urlitems.addAll(_results.getRange(0, 9));
    });
    }
    else
    {
      setState(() {
        urlitems.addAll(_results.getRange(0, _results.length));
      });
      
    }
    
   
  }
  //request for msg part
  _getResponseMsg() async{
    print("msg");
    Map<String, String> headers = {"API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
    http.Response response = await http.get("https://backend.scrapshut.com/api/msg/",headers: headers);
    _msgdata = jsonDecode(response.body);
   // print(response.body);

    print("message data after decode");
    print(_msgdata);
    setState(() {
      _msgresults = _msgdata['results'];
    });
    if(_msgresults.length>10)
    {
       setState(() {
      msgitems.addAll(_msgresults.getRange(0, 9));
    });

    }
    else
    {
      setState(() {
        msgitems.addAll(_msgresults.getRange(0,_msgresults.length));
      });
    }
   
    setState(() {
      isFetchingmsg = false;
    });
    
    print(_msgresults.length);
  }
  
 List<dynamic> userresults = List();
 String uid;
   _makeGetUserRequest() async {
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

     userresults = val['results'];
     uid = userresults[0]["userid"];
 
  print(userresults);
  print(uid.toString());
  
  }
  
 
  @override
  void initState() {
    // TODO: implement initState
    //initializing the tab controller and calling get requests
     _tabController = new TabController(length: 3,initialIndex: 0, vsync: this);
      _makeGetUserRequest();
    _getResponse();
    _getResponseMsg();
   
    
    

    
    
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar( 
        automaticallyImplyLeading: false,
        title: Text(
  
      "Wiringbridge" ,
    style: TextStyle(
      color: Colors.white,
       fontFamily: "Signatra" ,
      fontSize:  50 
    ),),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
    bottom:
    //adding tab bar
     new  TabBar(
         controller: _tabController,
          indicatorColor: Colors.white,
      tabs: [
        Tab(
          text: "URL",
        ),
        Tab(
          text: "Message",
        ),
        Tab(
          text: "Image",
        )
      ],
    ),),
      
      body : TabBarView(
        controller: _tabController,
        children: <Widget>[
          //while isfetching is true a circular indicator is shown
           isfetching==true  ? Center(child: CircularProgressIndicator()) :
     //returns the container from the method display that takes the response values as parameters
     
      ListView.builder(
        itemCount: (presentURL <= _results.length) ? urlitems.length + 1 : urlitems.length,
        //itemCount: urlitems.length,
        itemBuilder: (context,index){
        
          return (index == urlitems.length ) ?
          //for load more button
        Container(
            color: Colors.greenAccent,
            child: FlatButton(
                child: Text("Load More"),
                onPressed: () {
                  setState(() {
    if((presentURL + perPageURL)> _results.length) {
        urlitems.addAll(
            _results.getRange(presentURL, _results.length));
    } else {
        urlitems.addAll(
            _results.getRange(presentURL, presentURL + perPageURL));
    }
    presentURL = presentURL + perPageURL;
});

                },
            ),
        ) :
          
             Display(
              rate: _results[index]['rate'] ?? 0, 
              author: _results[index]['author'] ?? "null",
              url:  _results[index]['url'] ?? "12345678910", 
              time: _results[index]["created_at"] , 
              content:  _results[index]['content'] ?? "nulll", 
              tags: _results[index]['tags'],
              isMsg: false,
              index: index,
              map: _results[index]["advertisement"] ?? null,
              pid: _results[index]["id"],
              uid: int.parse(uid),
              );
        },
      ),

     isFetchingmsg == true ? Center(child: CircularProgressIndicator(),) :
      ListView.builder(
        itemCount:   (presentmsg <= _msgresults.length) ? msgitems.length + 1 : msgitems.length,
        itemBuilder: (context,index){
          
          return (index == msgitems.length ) ?
          //for load more button
        Container(
            color: Colors.greenAccent,
            child: FlatButton(
                child: Text("Load More"),
                onPressed: () {
                  setState(() {
    if((presentmsg + perPagemsg)> _msgresults.length) {
        msgitems.addAll(
            _msgresults.getRange(presentmsg, _msgresults.length));
    } else {
        msgitems.addAll(
            _msgresults.getRange(presentmsg, presentmsg + perPagemsg));
    }
    presentmsg = presentmsg + perPagemsg;
});

                },
            ),
        ) :
         
         Display(
           rate: _msgresults[index]["rate"] ?? 0,
           author: _msgresults[index]['author'] ?? "null",
           content: _msgresults[index]['content'] ?? "null",
           isMsg: true,
           index: index,
           map: null,
           tags: _msgresults[index]['tags'] ,
           time: _msgresults[index]["created_at"] ,
           url: _msgresults[index]['review'] ?? "12345678910",
           pid: _msgresults[index]["id"],
           uid: int.parse(uid),
         );
        },
      ),
     //get the images detais from images file in widgets
      Images(),
        ],
        
      )
     
      
    );
  }
 

}
class Overlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      
    );
  }
}
class Display extends StatefulWidget {
  
  final int rate;
  final String author;
  final String url;
  final String time;
  final String content;
  final List tags;
  final bool isMsg;
  final int index;
  final Map<String,dynamic> map;
  final int pid;
  final int uid;
  Display({this.rate,this.author,this.url,this.time,this.content,this.tags,this.isMsg,this.index,this.map,this.pid,this.uid});
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  Map<String,dynamic> res = Map();
  Map<String,dynamic> resd = Map();
  int coun =0;
  makeupvote(int uid,int pid) async
  {
    Map<String, String> headers = {"API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
    String url = "https://backend.scrapshut.com/api/post/vote/$pid/$uid/upvote";
    print(url);
    http.Response response = await http.get(url,headers: headers);
    print(response.body);
    print(response.statusCode);
    res = jsonDecode(response.body);
    setState(() {
      coun = res["upvotes"];
    });
  }
  makedownvote(int uid,int pid) async
  {
    Map<String, String> headers = {"API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
    String url = "https://backend.scrapshut.com/api/post/vote/$pid/$uid/downvote";
    print(url);
    http.Response response = await http.get(url,headers: headers);
    print(response.body);
    print(response.statusCode);
    resd = jsonDecode(response.body);
    setState(() {
      coun = resd["upvotes"];
    });
  }
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
    
    return widget.index%9 == 0  && widget.index>0?
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
            child: Container(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Imagine your product or service here.",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Target the exact people ",style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    )
    :
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
                    makeupvote(widget.uid, widget.pid);
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
                Text(coun.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                   GestureDetector(
                     onTap: (){
                       print("Stop");
                       makedownvote(widget.uid, widget.pid);
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
              
                              child: widget.map!=null ? ExpansionTile(
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

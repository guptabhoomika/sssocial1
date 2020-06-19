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

//      isFetchingmsg == true ? Center(child: CircularProgressIndicator(),) :
//       ListView.builder(
//         itemCount:   (presentmsg <= _msgresults.length) ? msgitems.length + 1 : msgitems.length,
//         itemBuilder: (context,index){
          
//           return (index == msgitems.length ) ?
//           //for load more button
//         Container(
//             color: Colors.greenAccent,
//             child: FlatButton(
//                 child: Text("Load More"),
//                 onPressed: () {
//                   setState(() {
//     if((presentmsg + perPagemsg)> _msgresults.length) {
//         msgitems.addAll(
//             _msgresults.getRange(presentmsg, _msgresults.length));
//     } else {
//         msgitems.addAll(
//             _msgresults.getRange(presentmsg, presentmsg + perPagemsg));
//     }
//     presentmsg = presentmsg + perPagemsg;
// });

//                 },
//             ),
//         ) :
         
//          Display(
//            rate: _msgresults[index]["rate"] ?? 0,
//            author: _msgresults[index]['author'] ?? "null",
//            content: _msgresults[index]['content'] ?? "null",
//            isMsg: true,
//            index: index,
//            map: null,
//            tags: _msgresults[index]['tags'] ,
//            time: _msgresults[index]["created_at"] ,
//            url: _msgresults[index]['review'] ?? "12345678910",
//            pid: _msgresults[index]["id"],
//            uid: int.parse(uid),
//          );
//         },
//       ),
Center(child: Text("It will be available soon"),),
     //get the images detais from images file in widgets
  Center(child: Text("It will be available soon"),),
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
  bool isadv = false;
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
   
    onchange()
    {
      setState(() {
        isexp = !isexp;
      });
      print(isexp.toString() +  " " + widget.index.toString());
      print(widget.map);
    }
     onchangeadv()
    {
      setState(() {
        isexp = !isexp;
        isadv = !isadv;
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
    

      height: isexp ? 435 : 280,
     decoration: BoxDecoration(
       border: Border.all(color: Colors.grey)
     ),
      duration: Duration(milliseconds:  50),
       
      margin: EdgeInsets.all(8),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
                      children: [
   
  Container(
    height: 70,
    width: MediaQuery.of(context).size.width,
    color: Colors.grey[200],
  ),
              
              widget.tags !=null ? Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: SizedBox(
                                height: 40,
                                                              child: Container(
                                  
                                  
                                  decoration: BoxDecoration(
                                     color: Colors.green,
                                     borderRadius: BorderRadius.circular(10)

                                  ),
                 
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.tags.toString().replaceAll("[", " ").replaceAll("]", " "),style: TextStyle(color: Colors.white),),
                  )),
                              ),
              ) : Container(),
             
          
              
],
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.url,style: TextStyle(color: Colors.blue,fontSize: 15),),
                ),
              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                   children: [

                     Text(coun.toString(),style: TextStyle(color: Colors.red),),
                     Icon(Icons.star,color: Colors.red,)
                   ],
                 ),
               )

            ],
           
          ),
           SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: (){
                onchangeadv();
              },
                          child: widget.map!=null && (widget.map["advertizing_content"]!=null && widget.map["title"]!=null && widget.map["url"]!=null) ?
                          Container(
                height: 40,
                width: 120,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: 
                  Text("Advertisement",style: TextStyle(color: Colors.white),) 
                ),
              ) : Container()
            ),
          ),
               Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                onchange();
              },
                          child: Container(
              height: 40,
                width: 120,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text("Show Reviews",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ),
            ],
          ),
          AnimatedContainer(
            //color: Colors.deepOrange,
            height: isexp? 200 : 10,
            duration: Duration(milliseconds: 50),
             
            child: isexp ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: isadv ? 
                  Text("Title: " + widget.map["title"]) :
                  Text(widget.author,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: isadv ?  Text("URL: "+ widget.map["url"]) :
                   Text("Review: "+widget.content),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  isadv ? Text("Content: " + widget.map["advertizing_content"]) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){makeupvote(widget.uid, widget.pid);},
                                                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/ok.png")
                            )
                        ),
                      ),
                          ),
                      SizedBox(width: 12,),
                      GestureDetector(
                        onTap: (){
                          makedownvote(widget.uid,widget.pid);
                        },
                                              child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/stop.png")
                            )
                          ),
                        ),
                      )
                        ],
                      ),
                   
                     
                    ],
                  ),
                ),
              ],
            )
             : Container()
          ),
         
        ],
      )
    );

    
  }
}

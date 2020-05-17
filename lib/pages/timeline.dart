import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sssocial/widgets/header.dart';
import 'package:sssocial/widgets/image.dart';
import 'package:sssocial/widgets/progress.dart';
import 'package:http/http.dart' as http;
class TimeLine extends StatefulWidget {
   

  @override
  _TimeLineState createState() => _TimeLineState();
}
Map<String,dynamic> _data;//stores response of get request from post endpoint
Map<String,dynamic> _msgdata;//stores response of get request from msg endpoint
List<dynamic> _msgresults; //stores the list of result of url
List<dynamic> _results; //stores the list of result of msg
 TabController _tabController;
 
bool isfetching = true; //to show circular loader while data is being fetched
bool isFetchingmsg = true;



class _TimeLineState extends State<TimeLine>  with SingleTickerProviderStateMixin{
  //url get request
  _getResponse() async //url get request
  {
    http.Response _response = await http.get("https://backend.scrapshut.com/api/post/");
    //print(_response.body);
    _data =  jsonDecode(_response.body);
    print(_data);
    setState(() {
      _results = _data['results'];
    });
    
    print(_results);
    setState(() {
      isfetching = false;
    });
    //setting is fetching false to display data
  }
  //request for msg part
  _getResponseMsg() async{
    http.Response response = await http.get("https://backend.scrapshut.com/api/msg/");
    _msgdata = jsonDecode(response.body);
    print("message data");
    print(_msgdata);
    setState(() {
      _msgresults = _msgdata['results'];
    });
    setState(() {
      isFetchingmsg = false;
    });
    print(_msgresults);
  }
  @override
  void initState() {
    // TODO: implement initState
    //initializing the tab controller and calling get requests
     _tabController = new TabController(length: 3,initialIndex: 0, vsync: this);
    _getResponse();
    _getResponseMsg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(
  
      "ScrapShut" ,
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
           isfetching==true ? Center(child: CircularProgressIndicator()) :
     //returns the container from the method display that takes the response values as parameters
      ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context,index){
          return display(_results[index]['rate'], _results[index]['author'], _results[index]['url'], _results[index]["created_at"],  _results[index]['content'], _results[index]['tags'],false);
        },
      ),

     isFetchingmsg == true ? Center(child: CircularProgressIndicator(),) :
      ListView.builder(
        itemCount: _msgresults.length,
        itemBuilder: (context,index){
          return display(_msgresults[index]['rate'], _msgresults[index]['author'], _msgresults[index]['review'], _msgresults[index]["created_at"],  _msgresults[index]['content'], _msgresults[index]['tags'],true);
        },
      ),
     //get the images detais from images file in widgets
      Images(pg: 0,),
        ],
        
      )
     
      
    );
  }
//method for building the ui in response to the api's values
//isMsg is swt to true to show data in corrospondence to the msg endpoint
  Container display(int rate,String author,String url,String time,String content,List tags,bool isMsg)
  
  {
  String c = time.substring(0,10);
    return Container(
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
                Icon(Icons.arrow_upward,),
                SizedBox(height: 5,),
                Text(rate.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Icon(Icons.arrow_downward)
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
                   Icon(Icons.blur_circular,color: Colors.blue,),
                   Text("r/news ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                   Text("Posted by u/",style: TextStyle(color: Colors.grey,fontSize: 10),),
                   Text(author + " ",style: TextStyle(color: Colors.grey,fontSize: 10)),
                   Text( "on " + c ,style: TextStyle(color: Colors.grey,fontSize: 7)),
                   
                   
              
                  
                   //Spacer(),
                 ],
               ),
               SizedBox(height: 10,),
               Text(content,style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                 tags.isNotEmpty ?  Text( "Tags: "+ tags.toString().replaceAll("[", " ").replaceAll("]", " " ),style: TextStyle(color: Colors.grey,fontSize: 10 )): Text("No tags ",style: TextStyle(color: Colors.grey,fontSize: 10 )),
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
                   Text("Comments",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                   SizedBox(width: 5,),
                   Icon(Icons.share,color: Colors.grey,),
                   SizedBox(width: 5,),
                   Text("Share",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold)),
                   SizedBox(width: 5,),
                   Icon(Icons.save_alt,color: Colors.grey),
                   SizedBox(width: 5,),
                   Text("Save",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold)),
                   SizedBox(width: 5,),
                   Text("...",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold))
                 ],
               )

             ],

            )
          )
        ],
      ),
    );

  }
}
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sssocial/widgets/header.dart';
import 'package:sssocial/widgets/progress.dart';
import 'package:http/http.dart' as http;
class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}
Map<String,dynamic> _data;
List<dynamic> _results;
bool isfetching = true;
class _TimeLineState extends State<TimeLine> {
  _getResponse() async
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
  }
  @override
  void initState() {
    // TODO: implement initState
    _getResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body : isfetching==true ? Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context,index){
          return display(_results[index]['rate'], _results[index]['author'], _results[index]['url'], _results[index]["created_at"],  _results[index]['content'], _results[index]['tags']);
        },
      )
      
    );
  }

  Container display(int rate,String author,String url,String time,String content,List tags)
  
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
              
               
               Row(children: <Widget>[
                  Text(url.substring(0,10),style: TextStyle(color: Colors.blue,fontSize: 10),),
                  Icon(Icons.call_made,color: Colors.blue,size: 10,)

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
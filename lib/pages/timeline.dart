import 'dart:convert';


import 'package:expandable/expandable.dart';
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
 Map<String,dynamic> _advertisementdata;
 
bool isfetching = true; //to show circular loader while data is being fetched
bool isFetchingmsg = true;
int perPageURL  = 10; //count of url shown in one page
int presentURL = 10; //indexing start from 10
List<dynamic> urlitems = List<dynamic>(); //temporary list to store url of a page
int perPagemsg  = 10; //count of msg shown in one page
int presentmsg = 10; //indexing start from 10
List<dynamic> msgitems = List<dynamic>(); //temporary list to store umsg of a page
bool isexp = false;





class _TimeLineState extends State<TimeLine>  with SingleTickerProviderStateMixin{
  isopen(bool state)
  {
    setState(() {
      isexp= state;
    });
  }
  //url get request
  _getResponse() async //url get request
  {
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
    return 
    Scaffold(
      appBar: AppBar( 
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
      
      body :
      TabBarView(
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
          display(_results[index]['rate'] ?? 0, _results[index]['author'] ?? "null", _results[index]['url'] ?? "12345678910", _results[index]["created_at"] ,  _results[index]['content'] ?? "nulll", _results[index]['tags'],false,index,_results[index]["advertisement"]);
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
          display(_msgresults[index]['rate'], _msgresults[index]['author'], _msgresults[index]['review'], _msgresults[index]["created_at"],  _msgresults[index]['content'], _msgresults[index]['tags'],true,index,null);
        },
      ),
     //get the images detais from images file in widgets
      Images(),
        ],
        
      )
     
      
    );
  }
//method for building the ui in response to the api's values
//isMsg is swt to true to show data in corrospondence to the msg endpoint
  Widget display(int rate,String author,String url,String time,String content,List tags,bool isMsg,int index,Map<String,dynamic> map)
  
  {
  // String c = time.substring(0,10);
  //   return index%9 == 0  && index>0?
  //   Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Card(
  //       elevation: 2.0,
  //           child: Container(
  //         height: 120,
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Text("Imagine your product or service here.",style: TextStyle(fontWeight: FontWeight.bold),),
  //               Text("Target the exact people ",style: TextStyle(fontWeight: FontWeight.bold)),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   )
  //   :
  //   Container(
  //     margin: EdgeInsets.all(8),
  //     height: 120,
  //     child: Row(
  //       children: <Widget>[
  //         Container(
  //           width: 40,
  //           color: Colors.grey[300],
            
            
  //           child: Column(
  //             children: <Widget>[
  //               Text(""),
  //               Icon(Icons.arrow_upward,),
  //               SizedBox(height: 5,),
  //               Text(rate.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
  //               SizedBox(height: 5,),
  //               Icon(Icons.arrow_downward)
  //             ],
  //           ),
            
  //         ),
  //         SizedBox(width: 10,),
  //         Container(
  //          child: Column(
  //            crossAxisAlignment: CrossAxisAlignment.start,
  //            children: <Widget>[
  //              Row(
  //                children: <Widget>[
  //                  Icon(Icons.blur_circular,color: Colors.blue,),
  //                  Text("r/news ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
  //                  Text("Posted by u/",style: TextStyle(color: Colors.grey,fontSize: 10),),
  //                  Text(author + " ",style: TextStyle(color: Colors.grey,fontSize: 10)),
  //                  Text( "on " + c ,style: TextStyle(color: Colors.grey,fontSize: 7)),
                   
                   
              
                  
  //                  //Spacer(),
  //                ],
  //              ),
  //              SizedBox(height: 10,),
  //              Text(content,style: TextStyle(fontWeight: FontWeight.bold),),
  //                 SizedBox(height: 5,),
  //                tags.isNotEmpty ?  Text( "Tags: "+ tags.toString().replaceAll("[", " ").replaceAll("]", " " ),style: TextStyle(color: Colors.grey,fontSize: 10 )): Text("No tags ",style: TextStyle(color: Colors.grey,fontSize: 10 )),
  //              SizedBox(height: 5,),
              
               
  //              Row(
  //                children: <Widget>[
  //                 Text( isMsg==true ? url : url.substring(0,10),style: TextStyle(color: Colors.blue,fontSize: isMsg? 15 : 10 ),),
  //                isMsg==true? Text(" ") : Icon(Icons.call_made,color: Colors.blue,size: 10,)

  //              ],),
              
  //              Spacer(),
  //              Row(
  //                children: <Widget>[
  //                  Icon(Icons.message,color: Colors.grey,),
  //                  SizedBox(width: 5,),
  //                  Text("Comments",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
  //                  SizedBox(width: 5,),
  //                  Icon(Icons.share,color: Colors.grey,),
  //                  SizedBox(width: 5,),
  //                  Text("Share",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold)),
  //                  SizedBox(width: 5,),
  //                  Icon(Icons.save_alt,color: Colors.grey),
  //                  SizedBox(width: 5,),
  //                  Text("Save",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold)),
  //                  SizedBox(width: 5,),
  //                  Text("...",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold))
  //                ],
  //              )

  //            ],

  //           )
  //         )
  //       ],
  //     ),
  //   );

   return index%9 == 0  && index>0?
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
    
      
     //height:  isexp ? 300 : 200,
     margin: EdgeInsets.all(9),
     decoration: BoxDecoration(
       border: Border.all(color: Colors.grey)
     ),
        duration: Duration(milliseconds: 20),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
          Stack(
                      children: <Widget>[
    Container(
  
                height: 50,
  
                width: MediaQuery.of(context).size.width,
  
                color: Colors.grey[300],
  
                
  
              ),
              Positioned(
                top: 10,
                left: 10,
                  bottom: 10,
                child:  tags.isEmpty ? Container() :
                Container(
  
                 
  
               
  
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(tags.toString().replaceAll("[", " ").replaceAll("]", " " ),style: TextStyle(color: Colors.white),),
                  ),
  
                  color: Colors.lightGreen[400],
  
  
  
                ),
              )
],
          ),
          SizedBox(height: 10,),
           Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text(url,style: TextStyle(color: Colors.blue,fontSize: 20),)),
                    Row(children: <Widget>[
                      Text(rate.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      SizedBox(height: 3,),
                      Icon(Icons.star,color: Colors.red,size: 25,),
                      
                    ],)
                  ],
                ),
              ),
            ),
          
          SizedBox(height: 30,),
          
         
     
            Row(
              children: <Widget>[
                Expanded(
                  child:  isMsg==false && map!=null ?
              Container(
                child: ExpansionTile(
                  trailing: Text(""),
                  title:   Container(
                    height: 50,
                    width: 110,
                    child: Card(
                             elevation: 2.0,
                                              child: Container(
                               
                               color: Colors.red,
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                 child: Text( "Sponsoer" ,style: TextStyle(color: Colors.white),),
                               ),
                             ),
                           ),
                  ),
                         children: <Widget>[
                          
                            Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Text("Title: " +map["title"],style:TextStyle(fontWeight: FontWeight.bold),),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Text("URL: "+map["url"],style:TextStyle(fontWeight: FontWeight.bold)),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Text("Content: " +map["advertizing_content"],style:TextStyle(fontWeight: FontWeight.bold)),
                                 )
                               ],
                             ),
                           
                         ],
                ),
              ) : Container()
            
                ),
                Expanded(
                  child: ExpansionTile(
                  

                    title: Container(height: 10,width: 0.1,),
                       //initiallyExpanded: false,
                       
                      onExpansionChanged: isopen,
                       trailing:  Container(
                         height: 50,
                         width: 100,
                         child: 
                            Card(
                             elevation: 2.0,
                                              child: Container(
                                                
                               
                               color: Colors.blue,
                               child: 
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10,top:3),
                                   child: Text( "Review" ,style: TextStyle(color: Colors.white),),
                                 ),
                               
                             ),
                           ),
                         
                       ),
                        
                       
                       children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 12,),
                            Text(author,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                             SizedBox(height: 8,),
                            Text("    Review: " + content,style: TextStyle(color: Colors.black54,fontSize: 15),),
                            SizedBox(height: 8,),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                     decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/stop.png",),fit: BoxFit.cover),
          
        ),
                                  ),
                                ),
                                 Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                     decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/ok.png",),fit: BoxFit.cover),
          
        ),
                                  ),
                                ),

                                //Icon(Icons.ac_unit,size: 40,color: Colors.yellow,)
                              ],
                            )
                            
                          ],),
                        )
                       ],
                     ),
                ),
                

              ],
            ),
              
              
           
                     
              
            
               
              
               
            SizedBox(height: 20,)
        
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
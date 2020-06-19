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
  // print(response.body);
  
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
          // print(response.body);
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
 
    setState(() {
      _msgresults = _msgdata['results'];
    });
    print("Message");

   setState(() {
     msgdata = true;
   });
    print(_msgresults.length);
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
              content:  _results[index]['review'] ?? "nulll", 
              tags: _results[index]['tags'],
              isMsg: false,
              index: index,
              map: _results[index]["advertisement"] ?? null,
              pid: _results[index]["id"],
             
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
           pid: _msgresults[index]["id"],
           
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
           //delete(id);
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
  final int pid;

  DisplayP({this.rate,this.author,this.url,this.time,this.content,this.tags,this.isMsg,this.index,this.map,this.pid});
  @override
  _DisplayPState createState() => _DisplayPState();
}

class _DisplayPState extends State<DisplayP> {
  Map<String,dynamic> res = Map();
  Map<String,dynamic> resd = Map();

  bool expd = false;
   bool isexp = false;
   bool isedit = false;
   TextEditingController _textEditingController;
   @override
  void initState() {
    // TODO: implement initState
    _textEditingController = new TextEditingController();
    super.initState();
  }
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
    edit()
    {
      print("in edit");
      setState(() {
        isedit = !isedit;
      });
    }
    put(int id,String text) async
    {
      print("in put");

      print(id);
      print(text);
        String bvalue = await Methods.storage.read(key: 'btoken');
        print(bvalue);
         String json = jsonEncode({
			
            "review": text
         });
      Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
              final http.Response response = await http.put(
    'https://backend.scrapshut.com/api/post/$id',
    headers:  headers,
    body: json,
    
  );
  print(response.statusCode);
print(response.body);
    }
  Future<http.Response> delete(int id) async {
     String bvalue = await Methods.storage.read(key: 'btoken');
    
    print("in delete");
    print(id);
    Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json","API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
          print(headers);
          final http.Response response = await http.delete(
    'https://backend.scrapshut.com/api/post/$id',
    headers:  headers,
    
    
  );
  
  print("delete");

  print(response.statusCode);
 
  print(response.body);
  
  
  return response;
}
deleteexp()
{
  setState(() {
    expd = !expd;
  });
}

    //print(widget.pid);
  String c = widget.time.substring(0,10);
    
    return 
  AnimatedContainer(
    

      height: isexp ? 420 : 250,
     decoration: BoxDecoration(
       border: Border.all(color: Colors.grey)
     ),
      duration: Duration(milliseconds: 50),
      curve: Curves.easeIn,
      margin: EdgeInsets.all(8),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
                      children: [
    AnimatedContainer(
  
                duration: Duration(milliseconds: 200) ,
  
                height: expd ? 80 : 60,
  
                color: Colors.grey[200],
  
              ),
              widget.tags !=null ? Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: SizedBox(
                                height: 40,
                              child: Container(
                                  
                                  width: 60,
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
              Positioned(
                top:  expd ? 0 : 10,
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  child: Icon(Icons.arrow_drop_down,color: Colors.blue,size: 30,),
                  onTap: (){
                    deleteexp();
                  },),
              ),
              Positioned(
                top: 40,
                bottom: 10,
                right: 10,
                child: expd? GestureDetector(
                  onTap: (){
                    delete(widget.pid);
                  },
                                  child: Container(
                    
                    height: 80,
                    width: 80,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(left:17,top: 8),
                      child: Text("Delete",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ) : Container() 

              )
          
              
],
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.url,style: TextStyle(color: Colors.blue,fontSize: 15),),
          ),
           SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 120,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text("Advertisement",style: TextStyle(color: Colors.white),),
              ),
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
            duration: Duration(milliseconds:50),
            curve: Curves.easeIn,
            child: isexp ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.author,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Review: "+widget.content),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/ok.png")
                          )
                        ),
                      ),
                      SizedBox(width: 12,),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/stop.png")
                          )
                        ),
                      )
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          if(isedit)
                          {
                              print(_textEditingController.text);
                            put(widget.pid, _textEditingController.text);
                              _textEditingController.clear();
                              edit();
                          //put(widget.pid,_textEditingController.text); 
                          }
                          else
                          {
                            edit();
                          }
                          
                        },
                          child: Container(

                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: isedit ? Text("Submit",textAlign: TextAlign.center) :
                          Text("EDIT",textAlign: TextAlign.center,),
                        ),
                      )
                     
                    ],
                  ),
                ),
                isedit ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                   
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
		borderRadius: BorderRadius.all(Radius.circular(0)),
		borderSide: BorderSide(color: Colors.black, width: 1),
	   ),
	  focusedBorder: OutlineInputBorder(
		borderRadius: BorderRadius.all(Radius.circular(0)),
		borderSide: BorderSide(color: Colors.black, width: 1),
	  ),
                        hintText: "Edit your review"
                      ),
                    ),
                  ),
                ) : Container()
              ],
            )
             : Container()
          ),
         
        ],
      )
    );


    
  }
}

 
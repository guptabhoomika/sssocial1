import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:sssocial/pages/home.dart';
 Map<String,dynamic> _data;

  List<dynamic> _results;
  List<dynamic> imgitems = List<dynamic>();

  bool havData = false;

class Images extends StatefulWidget {
  
 


  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  int perPageURL  = 10; //count of img shown in one page
int presentURL = 5; //indexing start from 10
 
    Future<String> _getResponse() async //url get request
  {
     Map<String, String> headers = {"API-KEY": "LrUyJbg2.hbzsN46K8ghSgF8LkhxgybbDnGqqYhKM"};
    http.Response _response = await http.get("https://backend.scrapshut.com/api/img/",headers: headers);
    //print(_response.body);
    _data =  jsonDecode(_response.body);
    print(_data);
    setState(() {
      _results = _data['results'];
    });
    
    print(_results);
    //print(_results[0]["picture"]);
    print(_results.length);
    if(_results.length>5)
    {
        setState(() {
      imgitems.addAll(_results.getRange(0, 5));
    });
    }
    else
    {
      setState(() {
        imgitems.addAll(_results.getRange(0, _results.length));
      });
    }
    
    setState(() {
      havData = true;
    });
    //setting is fetching false to display data
    return "Success";
  }
   
  @override
  void initState() {
    // TODO: implement initState
    
    
      _getResponse();
    
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return  havData == false ? 
   Center(child: CircularProgressIndicator()) :
   StaggeredGridView.countBuilder(
  crossAxisCount: 4,
  itemCount: (presentURL <= _results.length) ? imgitems.length + 1 : imgitems.length,
  itemBuilder: (BuildContext context, int index) => 
   (index == imgitems.length ) ?
          //for load more button
      
             FlatButton(
                child: Text("Load More"),
                //color: Colors.green,
                onPressed: () {
                  setState(() {
    if((presentURL + perPageURL)> _results.length) {
        imgitems.addAll(
            _results.getRange(presentURL, _results.length));
    } else {
        imgitems.addAll(
            _results.getRange(presentURL, presentURL + perPageURL));
    }
    presentURL = presentURL + perPageURL;
});

                },
            
        ) :
  Tile(url:_results[index]["picture"],index :index),
 
  staggeredTileBuilder: (int index) =>
      new StaggeredTile.count(2,  index.isEven ? 4 : 3),
 
  
);
   
      
    
  }
}
class Tile extends StatelessWidget {
  const Tile( {this.url,this.index});

  final String url;
  final int index;
  @override
  Widget build(BuildContext context) {
    return index %10 ==0 && index > 0 ?
    Card(
        elevation: 4.0,
            child: Container(
              color: Colors.greenAccent,
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Imagine your product or service here.",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Target the exact people ",style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      )
  
    :

    Card(
      
      child:  InkWell(
        onTap: () {},
       
          
           child:  new Center(
              child: new Padding(
                padding: const EdgeInsets.all(4.0),
                
                 child: new Container(
                   
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     image: DecorationImage(
                       image: NetworkImage(url,),
                       fit: BoxFit.cover
                     )
                   ),
                 )
            
          ),
                  
                              ),
                
          ),
      
        
      
    );
  }
}

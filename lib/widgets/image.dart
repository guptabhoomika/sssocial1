import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:sssocial/pages/home.dart';
 Map<String,dynamic> _data;

  List<dynamic> _results;

  bool havData = false;

class Images extends StatefulWidget {
  final int pg;
  Images({this.pg});
 


  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
 
    Future<String> _getResponse() async //url get request
  {
    http.Response _response = await http.get("https://backend.scrapshut.com/api/img/");
    //print(_response.body);
    _data =  jsonDecode(_response.body);
    print(_data);
    setState(() {
      _results = _data['results'];
    });
    
    print(_results);
    print(_results[0]["picture"]);
    print(_results.length);
    setState(() {
      havData = true;
    });
    //setting is fetching false to display data
    return "Success";
  }
   _getResponseImg() async{
    String bvalue = await storage.read(key: 'btoken');
    Map<String, String> headers = {"Authorization":"JWT $bvalue",
          "Content-Type":"application/json"};
          String url = "https://backend.scrapshut.com/user/img/";
    http.Response response = await http.get(url,headers: headers);
    print("img");
     print(response.statusCode);
     print(response.body);
     _data =  jsonDecode(response.body);
    print(_data);
    setState(() {
      _results = _data['results'];
    });
    
    print(_results);
    print(_results[0]["picture"]);
    print(_results.length);
    setState(() {
      havData = true;
    });
   
  }


  @override
  void initState() {
    // TODO: implement initState
    if(widget.pg==1)
    {
      _getResponseImg();
    }
    else if(widget.pg ==0)
    {
      _getResponse();
    }
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return  havData == false ? Center(child: CircularProgressIndicator()) :
   StaggeredGridView.countBuilder(
  crossAxisCount: 4,
  itemCount: _results.length,
  itemBuilder: (BuildContext context, int index) => Tile(_results[index]["picture"]),
 
  staggeredTileBuilder: (int index) =>
      new StaggeredTile.count(2,  index.isEven ? 4 : 3),
 
  
);
   
      
    
  }
}
class Tile extends StatelessWidget {
  const Tile( this.url);

  final String url;
  @override
  Widget build(BuildContext context) {
    return Card(
      
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

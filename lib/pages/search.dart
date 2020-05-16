import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
  
class _SearchState extends State<Search> {
 Map<String, dynamic> data;
 List users;
  getData() async{
    http.Response _response = await http.get("https://backend.scrapshut.com/user/all/?format=json");
    print("Search pg");
    print(_response.body);
    setState(() {
      
      data = jsonDecode(_response.body);
      users = data['results'];
    });
    // print(data);
    // print(data['count']);
    // print(users);

  }
  TextEditingController _textEditingController;
  List suggestions;
  @override
  void initState() {
    // TODO: implement initState
    _textEditingController = TextEditingController();
    suggestions = List();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextFormField(
            controller: _textEditingController,
            onChanged: (val){
              setState(() {
                 suggestions =buidSuggestions(val);
              });
             
            },
            decoration: InputDecoration(
              filled: true,
              hintText: "Search for a user...",
              prefixIcon: Icon(
                Icons.account_box,
                size: 28,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: (){_textEditingController.clear();suggestions.removeRange(0, suggestions.length);},
              )
            ),
          ),
          
        ),
        body: suggestions.isEmpty || _textEditingController.text.length == 0 ? buidNoContent() : buildContainer(suggestions),
      ),
      
    );
  }
  Container buidNoContent()
  {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
    
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(child: Image.asset("assets/images/active-search.png",height: orientation == Orientation.portrait ? 300 : 200)),
            Center(child: Text("Find Users",style: TextStyle(
              fontSize: 40,
              fontFamily: "Signatra",
              fontWeight: FontWeight.w100
            ),))

          ],
        ),
      ),
    );

  }
  Widget buildContainer(List _suggestionList)
  {
    return ListView.builder(
      itemCount: _suggestionList.length,
      itemBuilder: (context,index){
        return Container(
          margin: EdgeInsets.all(8),
         
          child: Row(children: <Widget>[
            Icon(Icons.account_box,color: Colors.purple,),
           
            
            Text(_suggestionList[index]['username'],style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),)
            ]),
        );
      },
    );
  }
 List buidSuggestions(String val)
  {
    final suggestionList = users.where((element) => element['username'].toString().toLowerCase().contains(val)).toList();
    print(suggestionList);
    return suggestionList;
    
         
           
           
      
  }
  
}
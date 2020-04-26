import 'package:flutter/material.dart';
import 'package:sssocial/widgets/header.dart';
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,titleText: "Profile"),
      body: Center(child: Text("profile")),
      
    );
  }
}
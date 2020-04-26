import 'package:flutter/material.dart';
import 'package:sssocial/widgets/header.dart';
import 'package:sssocial/widgets/progress.dart';
class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body: Center(child: Text("Timeline"))
      
    );
  }
}
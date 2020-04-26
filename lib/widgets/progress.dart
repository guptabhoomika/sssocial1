import 'package:flutter/material.dart';
Container circularprogress()
{
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:10),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}
Container linearprogress()
{
  return Container(
    //alignment: Alignment.center,
    padding: EdgeInsets.only(bottom:10),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}
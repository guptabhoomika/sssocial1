

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sssocial/pages/timeline.dart';
import 'package:sssocial/pages/userprofile.dart';
class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}


class _AuthState extends State<Auth> {
  PageController _pageController;
int pageIndex = 0;
  onPageCahnged(int index)
{
  setState(() {
    pageIndex = index;
  });
}
ontap(int index)
{
  _pageController.animateToPage(
    index,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut
    );
}
@override
  void initState() {
    // TODO: implement initState
    _pageController = PageController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLine(),
         
          UserProfile()


        ],
        controller: _pageController,
        onPageChanged: onPageCahnged,
        physics: NeverScrollableScrollPhysics(),
        
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: ontap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          // BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          // BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size:35.0)),
          // BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
  );
      
    
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_flutter_project/screens/account.dart';
import 'package:test_flutter_project/screens/phototape.dart';
import 'package:test_flutter_project/screens/profilePage.dart';
import 'package:test_flutter_project/screens/upload.dart';

class NewsFeedPage extends StatefulWidget {
  NewsFeedPage({Key key}) : super(key: key);
  final List<Widget> screens = [
    new PhotoTapePage(),
    new UploadPage(),
    new ProfilePage()
  ];

  @override
  State<StatefulWidget> createState() => NewsFeedPageState();
}

class NewsFeedPageState extends State<NewsFeedPage> {
  File file;
  int _pageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.wallpaper), title: new Text('feed')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.add_a_photo),
                title: new Text('add new photo')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.account_box_rounded),
                title: new Text('account'))
          ],
          onTap: (int index) {
            setState(() {
              _pageIndex = index;
            });
          },
          currentIndex: _pageIndex,
        ),
        body: IndexedStack(
          index: _pageIndex,
          children: widget.screens,
        ));
  }
}

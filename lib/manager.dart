import 'package:cnect/views/announcements/announcements.dart';
import 'package:cnect/views/home/home.dart';
import 'package:cnect/views/map/map.dart';
import 'package:flutter/material.dart';

class Manager extends StatefulWidget {

  Manager({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManagerState();
  }
}

class _ManagerState extends State<Manager> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeView(),
    MapView(),
    AnnouncementsView()
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Theme.of(context).bottomAppBarColor,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        /*selectedIconTheme: IconThemeData(
            color: Theme.of(context).accentColor
        ),
        selectedLabelStyle: TextStyle(
            color: Theme.of(context).accentColor
        ),
        selectedItemColor: Theme.of(context).accentColor,
        unselectedIconTheme: Theme.of(context).accentIconTheme,
        unselectedLabelStyle: TextStyle(
            color: Theme.of(context).accentIconTheme.color
        ),
        unselectedItemColor: Theme.of(context).accentIconTheme.color,*/
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Announcements',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
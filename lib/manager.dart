import 'package:flutter/material.dart';

import 'package:cnect/views/announcements/announcements.dart';
import 'package:cnect/views/home/home.dart';
import 'package:cnect/views/map/map.dart';

class Manager extends StatefulWidget {

  Manager({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManagerState();
  }
}

class _ManagerState extends State<Manager> {

  // Create tabs for navigation tab bar
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
    // Create the scaffold to hold the bottom navigation bar
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
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

  // Switch the current tab to the selected index
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
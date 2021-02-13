import 'package:flutter/material.dart';

class AnnouncementsView extends StatefulWidget {
  AnnouncementsView();

  @override
  _AnnouncementsViewState createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('Test'),
      ),
    );
  }

}
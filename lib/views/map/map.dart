import 'package:flutter/material.dart';

class MapView extends StatefulWidget {
  MapView();

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
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
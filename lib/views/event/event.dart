import 'package:cnect/models/event.dart';
import 'package:flutter/material.dart';

class EventView extends StatefulWidget {
  EventView(this.event);

  final Event event;

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
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
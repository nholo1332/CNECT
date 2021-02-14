import 'package:cnect/models/event.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/utils.dart';
import 'package:cnect/widgets/dateStickyHeader.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade800,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    Globals.currentUser.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: buildContent(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildContent(BuildContext context) {
    if ( Globals.currentUser.events.length > 0 ) {
      return buildEventList(context);
    } else {
      return Column(
        children: <Widget>[
          SizedBox(height: 45),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'You have no upcoming events',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  buildEventList(BuildContext context) {
    List<Event> events = Globals.currentUser.events;
    List<Widget> slivers = List<Widget>();
    int firstIndex = 0;

    for ( int i = 0; i < events.length; i++ ) {
      if ( i > 0 && ( !Utils.isSameDate(events[i - 1].startTime, events[i].startTime) || i + 1 == events.length ) ) {
        int count = events.getRange(firstIndex, i).length;
        slivers.addAll(DateStickyHeader().buildSideHeaderGrids(context, firstIndex, count, events));
        firstIndex = i;
      }
    }

    ScrollController scrollController = ScrollController(
        initialScrollOffset: findScrollOffset(events.length),
    );
    CustomScrollView scrollView = CustomScrollView(
      slivers: slivers,
      controller: scrollController,
    );

    return scrollView;
  }

  double findScrollOffset(int count) {
    double itemHeight = 72;
    for (int j = 0; j < count; j++) {
      DateTime eventDate = Globals.currentUser.events[j].startTime;
      DateTime now = DateTime.now();
      if (eventDate.year == now.year && eventDate.month == now.month) {
        if (Utils.isSameDate(eventDate, now)) {
          return j * itemHeight;
        } else if (eventDate.isAfter(now)) {
          return j * itemHeight;
        }
      } else {
        return 0;
      }
    }
    return 0;
  }
}
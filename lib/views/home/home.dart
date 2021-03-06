import 'package:flutter/material.dart';

import 'package:cnect/models/business.dart';
import 'package:cnect/models/community.dart';
import 'package:cnect/models/event.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/utils.dart';
import 'package:cnect/widgets/businessEventStickyHeader.dart';
import 'package:cnect/widgets/dateStickyHeader.dart';
import 'package:cnect/widgets/profileBottomSheet.dart';

class HomeView extends StatefulWidget {
  HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TabController controller;
  int selectedIndex = 0;

  List<Widget> tabs = [
    Tab(
      child: Text('My Events'),
    ),
    Tab(
      icon: Text('Community'),
    ),
    Tab(
      icon: Text('Business'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the tab bar controller and set current (first) tab
    controller = TabController(
      length: tabs.length,
      vsync: this,
    );
    controller.addListener(() {
      setState(() {
        selectedIndex = controller.index;
      });
    });

    // Check if global selected community exists, and if not, set its value
    if ( Globals.selectedCommunity == null ) {
      Globals.selectedCommunity = Globals.currentUser.communities.first;
    }
  }

  // Main view body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: scaffoldKey,
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
                  Row(
                    children: [
                      Text(
                        'Welcome,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.only(right: 25),
                              child: InkWell(
                                customBorder: new CircleBorder(),
                                child: Icon(
                                  Icons.account_circle,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onTap: () => ProfileBottomSheet().showProfileBottomSheet(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    Globals.currentUser.name + (
                      Globals.currentUser.events.length > 0
                          ? ' - Here are some of your upcoming events'
                          : ''
                    ),
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
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          child: TabBar(
                            tabs: tabs,
                            controller: controller,
                            labelColor: Theme.of(context).primaryColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              buildMyEventsContent(context),
                              Container(
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 20,
                                        left: 25,
                                        right: 25,
                                      ),
                                      child: DropdownButton<Community>(
                                        value: Globals.selectedCommunity,
                                        isExpanded: true,
                                        items: Globals.currentUser.communities.map((Community value) {
                                          return DropdownMenuItem<Community>(
                                            value: value,
                                            child: Text(
                                              value.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            Globals.selectedCommunity = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: buildCommunityEvents(context),
                                    ),
                                  ],
                                ),
                              ),
                              buildBusinessEvents(context),
                            ],
                            controller: controller,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the My Events tab content
  buildMyEventsContent(BuildContext context) {
    if ( Globals.currentUser.events.length > 0 ) {
      return Padding(
        padding: EdgeInsets.only(top: 5),
        child: buildEventList(
          context,
          Globals.currentUser.events,
          false,
        ),
      );
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

  // Build the event list with current day side sticky header
  buildEventList(BuildContext context, List<Event> events, bool showCheckMark) {
    List<Widget> slivers = List<Widget>();
    int firstIndex = 0;

    // Loop through events
    for ( int i = 0; i < events.length; i++ ) {
      // If the previous loop returned an event that has a different date than
      // this loop's event, split at the last range and create sticky header and
      // list items for that group
      if ( i > 0 && ( !Utils.isSameDate(events[i - 1].startTime, events[i].startTime) || i + 1 == events.length ) ) {
        int count = events.getRange(firstIndex, i).length;
        slivers.addAll(
          DateStickyHeader().buildSideHeaderGrids(
            context,
            firstIndex,
            count,
            events,
            showCheckMark: showCheckMark,
          ),
        );
        firstIndex = i;
      }

      // If there is only one event or it is on the last events, add that group
      // between loops
      if ( ( i + 1 ) == events.length ) {
        slivers.addAll(
          DateStickyHeader().buildSideHeaderGrids(
            context,
            firstIndex,
            events.length - firstIndex,
            events,
            showCheckMark: showCheckMark,
          ),
        );
      }
    }

    ScrollController scrollController = ScrollController(
        initialScrollOffset: findScrollOffset(
          events.length,
          events,
        ),
    );
    CustomScrollView scrollView = CustomScrollView(
      slivers: slivers,
      controller: scrollController,
    );

    return scrollView;
  }

  // Build all community events list
  Widget buildCommunityEvents(BuildContext context) {
    if ( Globals.currentUser.communities.length != 0 ) {
      // Use a Future to load data and show the loading indicator while waiting
      return FutureBuilder<List<Event>>(
        future: Backend.getAllCommunityEvents(Globals.selectedCommunity.id),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          if ( snapshot.hasData ) {
            return Padding(
              padding: EdgeInsets.only(top: 5),
              child: buildEventList(
                context,
                snapshot.data,
                true,
              ),
            );
          } else if ( snapshot.hasError ) {
            return Center(
              child: Text(
                'Failed to load community events',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      );
    } else {
      return Center(
        child: Text(
          'You are currently not a part of a community.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }
  }

  // Show the business events with the sticky header that has the business name
  Widget buildBusinessEvents(BuildContext context) {
    if ( Globals.currentUser.followedBusinesses.length != 0 ) {
      return FutureBuilder<List<Business>>(
        future: Backend.getAllFollowedBusinessesEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Business>> snapshot) {
          if ( snapshot.hasData ) {
            return Container(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                        bottom: 5,
                      ),
                      child: Text(
                        'View events from businesses you follow',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: buildBusinessEventList(
                        context,
                        snapshot.data,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if ( snapshot.hasError ) {
            return Center(
              child: Text(
                'Failed to load business events',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      );
    } else {
      return Center(
        child: Text(
          'You are currently not following any businesses.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }
  }

  // Build the list seen on the business tab. Create a sticky header for each
  // business and list the events underneath
  buildBusinessEventList(BuildContext context, List<Business> businesses) {
    List<Widget> slivers = List<Widget>();

    businesses.forEach((b) {
      slivers.addAll(
        BusinessEventStickyHeader().build(
          context,
          b.events,
          b.name,
        ),
      );
    });

    CustomScrollView scrollView = CustomScrollView(
      slivers: slivers
    );

    return scrollView;
  }

  // Calculate the scroll offset and to what scroll position the app should
  // default. This provides the user with an easy way to see today's events.
  // However, there may not always be enough events to scroll, so the safety is
  // not scrolling (or setting the position to 0;
  double findScrollOffset(int count, List<Event> events) {
    double itemHeight = 72;
    // Loop through events
    for ( int j = 0; j < count; j++ ) {
      DateTime eventDate = events[j].startTime;
      DateTime now = DateTime.now();
      // Compare dates to determine scroll position
      if ( eventDate.year == now.year && eventDate.month == now.month ) {
        if ( Utils.isSameDate(eventDate, now) ) {
          return j * itemHeight;
        } else if ( eventDate.isAfter(now) ) {
          return j * itemHeight;
        }
      } else {
        return 0;
      }
    }
    return 0;
  }
}
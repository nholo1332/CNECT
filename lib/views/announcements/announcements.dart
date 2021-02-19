import 'package:cnect/models/announcement.dart';
import 'package:cnect/models/business.dart';
import 'package:cnect/models/community.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/widgets/largeRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementsView extends StatefulWidget {
  AnnouncementsView();

  @override
  _AnnouncementsViewState createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TabController controller;
  int selectedIndex = 0;

  List<Widget> tabs = [
    Tab(
      icon: Text('Community'),
    ),
    Tab(
      icon: Text('Business'),
    ),
  ];

  double panelHeightOpen = 500;
  double panelHeightClosed = 90;

  Announcement selectedAnnouncement;

  PanelController panelController;

  @override
  void initState() {
    super.initState();
    panelController = new PanelController();
    controller = TabController(
      length: tabs.length,
      vsync: this,
    );

    controller.addListener(() {
      setState(() {
        selectedIndex = controller.index;
      });
    });

    if ( Globals.selectedCommunity == null ) {
      Globals.selectedCommunity = Globals.currentUser.communities.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: buildMain(),
    );
  }

  Widget buildMain() {
    if ( selectedAnnouncement == null ) {
      return body();
    } else {
      return SlidingUpPanel(
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        controller: panelController,
        backdropEnabled: true,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        body: body(),
        panelBuilder: (sc) => panelBuilder(sc),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      );
    }
  }

  Widget body() {
    return Container(
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
                  'Announcements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
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
                                    child: buildCommunityAnnouncements(context),
                                  ),
                                ],
                              ),
                            ),
                            buildBusinessAnnouncements(context),
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
    );
  }
  
  buildAnnouncementList(BuildContext context, List<Announcement> announcements) {
    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        return buildAnnouncementItem(announcements[index]);
      },
    );
  }

  Widget buildAnnouncementItem(Announcement announcement) {
    return Container(
      height: 115,
      child: Card(
        elevation: 2,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.campaign,
                        size: 35,
                      ),
                      title: Text(announcement.title),
                      subtitle: Text(
                        announcement.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat('MMMM dd, yyyy').format(announcement.publishDate),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                selectedAnnouncement = announcement;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget buildCommunityAnnouncements(BuildContext context) {
    if ( Globals.currentUser.communities.length != 0 ) {
      return FutureBuilder<List<Announcement>>(
        future: Backend.getAllCommunityAnnouncements(Globals.selectedCommunity.id),
        builder: (BuildContext context, AsyncSnapshot<List<Announcement>> snapshot) {
          if ( snapshot.hasData ) {
            return Container(
              width: double.infinity,
              child: buildAnnouncementList(
                context,
                snapshot.data,
              ),
            );
          } else if ( snapshot.hasError ) {
            print(snapshot.error);
            return Center(
              child: Text(
                'Failed to load community announcements',
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

  Widget panelBuilder(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Padding(
        padding: EdgeInsets.only(top: 12),
        child: ListView(
          controller: sc,
          children: <Widget>[
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(right: 25),
                    child: InkWell(
                      customBorder: new CircleBorder(),
                      child: Icon(
                        Icons.close_rounded,
                        size: 24,
                        color: Colors.black,
                      ),
                      onTap: () {
                        panelController.close();
                        setState(() {
                          selectedAnnouncement = null;
                        });
                      },
                    ),
                  )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  selectedAnnouncement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Text(
                selectedAnnouncement.description,
                softWrap: true,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 36),
            Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'More',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12),
                  LargeRoundedButton(
                    horizontalMargin: 10,
                    backgroundColor: Theme.of(context).accentColor,
                    childWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.link,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Website',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTapAction: () => openLink(selectedAnnouncement.url),
                  ),
                ],
              ),
            ),
            SizedBox(height: 36),
            Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Community',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12),
                  buildCommunityCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommunityCard() {
    return Padding(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.location_city,
                size: 35,
              ),
              title: Text(Globals.selectedCommunity.name),
              subtitle: Globals.selectedCommunity.description != ''
                  ? Text(Globals.selectedCommunity.description)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBusinessAnnouncements(BuildContext context) {
    if ( Globals.currentUser.followedBusinesses.length != 0 ) {
      return FutureBuilder<List<Business>>(
        future: Backend.getAllFollowedBusinessesAnnouncements(),
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
                        'View announcements from businesses you follow',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: buildBusinessAnnouncementList(
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
                'Failed to load business announcements',
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

  buildBusinessAnnouncementList(BuildContext context, List<Business> businesses) {
    List<Widget> slivers = List<Widget>();

    businesses.forEach((b) {
      slivers.addAll(
        buildAnnouncementStickHeaders(
          b.announcements,
          b.name,
        ),
      );
    });

    CustomScrollView scrollView = CustomScrollView(
        slivers: slivers
    );

    return scrollView;
  }

  List<Widget> buildAnnouncementStickHeaders(List<Announcement> announcements, String businessName) {
    return List.generate(1, (sliverIndex) {
      return SliverStickyHeader(
        header: Container(
          height: 60,
          color: Theme.of(context).accentColor,
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            businessName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, i) =>
              GestureDetector(
                child: buildAnnouncementItem(announcements[i]),
              ),
            childCount: announcements.length,
          ),
        ),
      );
    });
  }

  openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to open link'),
        ),
      );
    }
  }

}
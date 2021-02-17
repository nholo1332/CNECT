import 'package:cnect/models/community.dart';
import 'package:cnect/models/event.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/utils.dart';
import 'package:cnect/views/event/socialSheet.dart';
import 'package:cnect/widgets/largeRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class EventView extends StatefulWidget {
  EventView(this.event);

  final Event event;

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController mapController;

  Event event;

  final Set<Marker> markers = {};

  LatLng eventCenter = LatLng(0, 0);

  int communityIndex;

  bool isLoadingRSVP = false;

  bool hasRSVP = false;

  void initState() {
    super.initState();
    event = widget.event;
    eventCenter = LatLng(event.location.lat, event.location.long);
    communityIndex = Globals.currentUser.communities.indexWhere((c) => c.id == event.community);
    hasRSVP = Globals.currentUser.events.indexWhere((e) => e.id == event.id) != -1;
  }

  @override
  Widget build(BuildContext context) {
    double textWrapContainerWidth = MediaQuery.of(context).size.width * 0.8;

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
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    mini: true,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    event.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        width: textWrapContainerWidth,
                        child: Text(
                          event.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        width: textWrapContainerWidth,
                        child: Text(
                          Utils.getEventLongDateText(event.startTime, event.endTime),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            rotateGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            myLocationButtonEnabled: false,
                            scrollGesturesEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: eventCenter,
                              zoom: 15,
                            ),
                            markers: markers,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: LargeRoundedButton(
                              horizontalMargin: 10,
                              backgroundColor: Theme.of(context).accentColor,
                              childWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTapAction: () {
                                SocialSheet().showSocialBottomSheet(context, event);
                              },
                            ),
                          ),
                          Expanded(
                            child: LargeRoundedButton(
                              horizontalMargin: 10,
                              backgroundColor: Theme.of(context).primaryColor,
                              childWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.near_me,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Get Directions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTapAction: () {
                                MapsLauncher.launchQuery(event.location.address);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      buildRSVP(),
                      SizedBox(height: 20),
                      buildCommunityText(),
                      buildCommunity(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void redactRsvp() {
    setState(() {
      isLoadingRSVP = true;
    });
    Backend.redactRSVP(event.id).then((value) {
      Globals.currentUser.events.remove(event);
      Globals.communityEvents = {};
      Globals.followedBusinessesEvents = [];
      setState(() {
        hasRSVP = false;
        isLoadingRSVP = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Redacted RSVP'),
        ),
      );
    }).catchError((error) {
      setState(() {
        isLoadingRSVP = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to redact RSVP'),
        ),
      );
    });
  }

  void rsvp() {
    setState(() {
      isLoadingRSVP = true;
    });
    Backend.addRSVP(event.id).then((value) {
      Globals.currentUser.events.add(event);
      Globals.communityEvents = {};
      Globals.followedBusinessesEvents = [];
      setState(() {
        hasRSVP = true;
        isLoadingRSVP = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Added RSVP'),
        ),
      );
    }).catchError((error) {
      setState(() {
        isLoadingRSVP = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to add RSVP'),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller)async  {
    mapController = controller;

    List<Placemark> place = await placemarkFromCoordinates(event.location.lat, event.location.long);
    Placemark placeMark = place[0];
    setState(() {
      markers.add(
        new Marker(
          markerId: MarkerId(placeMark.name),
          position: eventCenter,
          infoWindow: InfoWindow(
            title: event.location.name != ''
                ? event.location.name
                : event.name + ' - Venue',
            snippet: event.location.address,
          ),
        ),
      );
    });
  }

  Widget buildRSVP() {
    if ( hasRSVP ) {
      return MaterialButton(
        child: isLoadingRSVP
            ? CircularProgressIndicator()
            : Text('Can\'t attend? Redact RSVP'),
        onPressed: isLoadingRSVP
            ? null
            : redactRsvp,
      );
    } else {
      return Container(
        child: Column(
          children: [
            Text('Want to attend?'),
            LargeRoundedButton(
              backgroundColor: Theme.of(context).primaryColor,
              childWidget: isLoadingRSVP
                  ? CircularProgressIndicator()
                  : Text(
                'RSVP Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTapAction: rsvp,
            ),
          ],
        ),
      );
    }
  }

  Widget buildCommunityText() {
    if ( communityIndex >= 0 ) {
      return Padding(
        padding: EdgeInsets.only(
          left: 8,
          bottom: 5,
        ),
        child: Align(
          child: Text(
            'Community',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildCommunity() {
    if ( communityIndex >= 0 ) {
      Community community = Globals.currentUser.communities[communityIndex];
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
                title: Text(community.name),
                subtitle: community.description != ''
                    ? Text(community.description)
                    : null,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

}
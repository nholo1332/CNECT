import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:cnect/models/business.dart';
import 'package:cnect/models/community.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/widgets/largeRoundedButton.dart';

class MapView extends StatefulWidget {
  MapView();

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController mapController;

  LatLng communityCenter = LatLng(0, 0);

  Set<Marker> markers = {};

  BitmapDescriptor pinLocationIcon;

  List<Community> communities;

  List<Business> businesses;

  Business selectedBusiness;

  bool isLoadingFollowStatus = false;

  final double initFabHeight = 120;
  double fabHeight = 20;
  double panelHeightOpen = 500;
  double panelHeightClosed = 90;

  void initState() {
    super.initState();
    // Check global selected community
    communities = Globals.currentUser.communities;
    if ( Globals.selectedCommunity == null ) {
      Globals.selectedCommunity = communities.first;
    }
    // Set community center set when creating community
    communityCenter = new LatLng(
      Globals.selectedCommunity.location.lat,
      Globals.selectedCommunity.location.long,
    );
    // Create the custom map icon we see to mark businesses on CNECT
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/mapMarker.png',
    ).then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Call the main build function
    return Scaffold(
      body: buildMain(),
    );
  }

  Widget buildMain() {
    if ( selectedBusiness == null ) {
      // Hide the SlidingUpPanel because no business has been selected
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          body(),
          Positioned(
            right: 20,
            bottom: fabHeight,
            child: FloatingActionButton(
              child: Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: communityCenter,
                      zoom: 15,
                    ),
                  ),
                );
              },
              backgroundColor: Theme.of(context).accentColor,
            ),
          ),
        ],
      );
    } else {
      // Show the sliding up panel because a business on the map has been
      // selected
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            backdropEnabled: true,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            body: body(),
            panelBuilder: (sc) => panelBuilder(sc),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            ),
            onPanelSlide: (double pos) => setState(() {
              // Move the FAB (re-center) button up to accommodate for the
              // SlidingUpPanel movement
              fabHeight = pos * ( panelHeightOpen - panelHeightClosed ) + initFabHeight;
            }),
          ),
          Positioned(
            right: 20,
            bottom: fabHeight,
            child: FloatingActionButton(
              child: Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: communityCenter,
                      zoom: 15,
                    ),
                  ),
                );
              },
              backgroundColor: Theme.of(context).accentColor,
            ),
          ),
        ],
      );
    }
  }

  Widget body() {
    // Create and display the map and main body content and the community
    // selector on top
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Use a Future to load the data and display a loading indicator in
          // the mean time
          FutureBuilder<List<Business>>(
            future: Backend.getBusinesses(Globals.selectedCommunity.id),
            builder: (BuildContext context, AsyncSnapshot<List<Business>> snapshot) {
              if ( snapshot.hasData ) {
                businesses = snapshot.data;
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: communityCenter,
                    zoom: 15,
                  ),
                );
              } else if ( snapshot.hasError ) {
                return Center(
                  child: Text(
                    'Failed to load map data',
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
          ),
          Padding(
            padding: EdgeInsets.only(top: 45),
            child: Card(
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: DropdownButton<Community>(
                  value: Globals.selectedCommunity,
                  isExpanded: true,
                  items: communities.map((Community value) {
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
                      // Remove selected business as the community may have
                      // changed
                      selectedBusiness = null;
                      Globals.selectedCommunity = value;
                      communityCenter = new LatLng(
                        Globals.selectedCommunity.location.lat,
                        Globals.selectedCommunity.location.long,
                      );
                      fabHeight = 20;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Callback ran after the map has been created. This is where the business
  // icons are added to the map and their touch event assigned
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    markers = {};
    Set<Marker> markerData = {};
    businesses.forEach((business) {
      markerData.add(
        Marker(
          markerId: MarkerId(business.id),
          icon: pinLocationIcon,
          position: LatLng(
            business.location.lat,
            business.location.long,
          ),
          onTap: () {
            setState(() {
              fabHeight = panelHeightClosed + 20;
              selectedBusiness = business;
            });
          },
        ),
      );
    });
    setState(() {
      // Refresh the view with the map markers
      markers = markerData;
    });
  }

  Widget panelBuilder(ScrollController sc) {
    // Build the SlidingUpPanel content
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
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  selectedBusiness.name,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 36),
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
                      // Open map app to navigate to the address
                      MapsLauncher.launchQuery(selectedBusiness.location.address);
                    },
                  ),
                ),
                Expanded(
                  child: buildFollowButton(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Text(
                'View these business announcements directly in your Announcements feed and All Events by following them.',
                softWrap: true,
                textAlign: TextAlign.center,
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
                    'About',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12),
                  Text(
                    selectedBusiness.description,
                    softWrap: true,
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

  // Build the community card found on the bottom of the business information
  // SlidingUpPanel
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

  // Build and control the logic for which follow button to display
  Widget buildFollowButton() {
    if ( Globals.currentUser.followedBusinesses.contains(selectedBusiness.id) ) {
      // Business is currently followed, so the unfollow button needs to be
      // displayed
      return LargeRoundedButton(
        horizontalMargin: 10,
        backgroundColor: Theme.of(context).primaryColor,
        childWidget: isLoadingFollowStatus ? CircularProgressIndicator() : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.remove_circle_outline_rounded,
                color: Colors.white,
              ),
            ),
            Text(
              'Unfollow',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTapAction: isLoadingFollowStatus
            ? null
            : unfollowBusiness,
      );
    } else {
      // Business is currently not followed, so the follow button needs to be
      // displayed
      return LargeRoundedButton(
        horizontalMargin: 10,
        backgroundColor: Theme.of(context).primaryColor,
        childWidget: isLoadingFollowStatus ? CircularProgressIndicator() : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.white,
              ),
            ),
            Text(
              'Follow',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTapAction: isLoadingFollowStatus
            ? null
            : followBusiness,
      );
    }
  }

  // Call the Backend function to unfollow the selected business
  void unfollowBusiness() {
    setState(() {
      isLoadingFollowStatus = true;
    });
    Backend.unfollowBusiness(selectedBusiness.id).then((value) {
      // Update globals to reflect the business unfollow action
      setState(() {
        Globals.currentUser.followedBusinesses.remove(selectedBusiness.id);
        Globals.followedBusinessesEvents = [];
        isLoadingFollowStatus = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Unfollowed business'),
        ),
      );
    }).catchError((error) {
      setState(() {
        isLoadingFollowStatus = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to unfollow business'),
        ),
      );
    });
  }

  // Call the Backend to follow the business
  void followBusiness() {
    setState(() {
      isLoadingFollowStatus = true;
    });
    Backend.followBusiness(selectedBusiness.id).then((value) {
      setState(() {
        // Update locally stored globals to reflect the newly followed business
        Globals.currentUser.followedBusinesses.add(selectedBusiness.id);
        Globals.followedBusinessesEvents = [];
        isLoadingFollowStatus = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Followed business'),
        ),
      );
    }).catchError((error) {
      setState(() {
        isLoadingFollowStatus = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to follow business'),
        ),
      );
    });
  }

}
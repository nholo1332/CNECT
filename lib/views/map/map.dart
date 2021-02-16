import 'package:cnect/models/business.dart';
import 'package:cnect/models/community.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  Community selectedCommunity;

  List<Business> businesses;

  Business selectedBusiness;

  final double initFabHeight = 120;
  double fabHeight = 120;
  double panelHeightOpen = 500;
  double panelHeightClosed = 90;

  void initState() {
    super.initState();
    communities = Globals.currentUser.communities;
    selectedCommunity = communities.first;
    communityCenter = new LatLng(selectedCommunity.location.lat, selectedCommunity.location.long);
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/mapMarker.png',
    ).then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMain(),
    );
  }

  Widget buildMain() {
    if ( selectedBusiness == null ) {
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
            onPanelSlide: (double pos) => setState((){
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
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          FutureBuilder<List<Business>>(
            future: Backend.getBusinesses(selectedCommunity.id),
            builder: (BuildContext context, AsyncSnapshot<List<Business>> snapshot) {
              if ( snapshot.hasData ) {
                businesses = snapshot.data;
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: communityCenter,
                    zoom: 15,
                  ),
                );
              } else if ( snapshot.hasError ) {
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('Failed to load map data'),
                  ),
                );
                return Container();
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
                width: 175,
                height: 50,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: DropdownButton<Community>(
                  value: selectedCommunity,
                  isExpanded: true,
                  items: communities.map((Community value) {
                    return DropdownMenuItem<Community>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommunity = value;
                      communityCenter = new LatLng(selectedCommunity.location.lat, selectedCommunity.location.long);
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

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    markers = {};
    Set<Marker> markerData = {};
    businesses.forEach((business) {
      markerData.add(
        Marker(
          markerId: MarkerId(business.id),
          icon: pinLocationIcon,
          position: LatLng(business.location.lat, business.location.long),
          onTap: () {
            setState(() {
              selectedBusiness = business;
            });
          },
        ),
      );
    });
    setState(() {
      markers = markerData;
    });
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
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
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
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 36.0),
          ],
        ),
      ),
    );
  }

}
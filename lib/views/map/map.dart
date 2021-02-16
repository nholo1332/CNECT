import 'package:cnect/models/business.dart';
import 'package:cnect/models/community.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  MapView();

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController mapController;

  LatLng communityCenter = LatLng(0, 0);

  List<Community> communities;

  Community selectedCommunity;

  void initState() {
    super.initState();
    communities = Globals.currentUser.communities;
    selectedCommunity = communities.first;
    communityCenter = new LatLng(selectedCommunity.location.lat, selectedCommunity.location.long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
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
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            FutureBuilder<List<Business>>(
              future: Backend.getBusinesses(selectedCommunity.id),
              builder: (BuildContext context, AsyncSnapshot<List<Business>> snapshot) {
                if ( snapshot.hasData ) {
                  
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationButtonEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
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
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller)async  {
    mapController = controller;
  }

}
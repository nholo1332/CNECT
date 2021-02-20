class LocationData {
  // Create model variables
  String address;
  double long;
  double lat;
  String name;

  LocationData({
    this.address,
    this.long,
    this.lat,
    this.name,
  });

  // Convert JSON to data model variables
  LocationData.fromJson(Map<String, dynamic> data) {
    address = data['address'];
    long = data['long'];
    lat = data['lat'];
    name = data['name'];
  }

  // Convert data model variables to JSON
  Map<String, dynamic> toJson() => {
    'address': address,
    'long': long,
    'lat': lat,
    'name': name,
  };
}

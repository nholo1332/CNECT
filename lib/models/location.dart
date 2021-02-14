class LocationData {
  String address;
  double long;
  double lat;

  LocationData({
    this.address,
    this.long,
    this.lat,
  });

  LocationData.fromJson(Map<String, dynamic> data) {
    address = data['address'];
    long = data['long'];
    lat = data['lat'];
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'long': long,
    'lat': lat,
  };
}

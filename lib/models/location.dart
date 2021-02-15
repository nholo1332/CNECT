class LocationData {
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

  LocationData.fromJson(Map<String, dynamic> data) {
    address = data['address'];
    long = data['long'];
    lat = data['lat'];
    name = data['name'];
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'long': long,
    'lat': lat,
    'name': name,
  };
}

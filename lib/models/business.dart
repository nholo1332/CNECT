import 'package:cnect/models/location.dart';

class Business {
  String id;
  String name;
  String description;
  LocationData location;

  Business({
    this.id,
    this.name,
    this.description,
    this.location,
  });

  Business.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    location = new LocationData.fromJson(data['location']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'location': location.toJson(),
  };
}

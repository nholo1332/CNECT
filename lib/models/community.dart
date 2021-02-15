import 'package:cnect/models/location.dart';

class Community {
  String id;
  String name;
  String description;
  LocationData location;
  List<String> businesses;

  Community({
    this.id,
    this.name,
    this.description,
    this.location,
    this.businesses,
  });

  Community.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    location = new LocationData.fromJson(data['location']);
    businesses = new List<String>.from(data['businesses']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'location': location.toJson(),
    'businesses': businesses,
  };
}

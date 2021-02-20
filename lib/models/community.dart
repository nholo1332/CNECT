import 'package:cnect/models/location.dart';

class Community {
  // Create model variables
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

  // Convert JSON to data model variables
  Community.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    // Convert JSON into variable with the LocationData
    location = new LocationData.fromJson(data['location']);
    // Create a list of business ID strings
    businesses = new List<String>.from(data['businesses']);
  }

  // Convert data model variables to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'location': location.toJson(),
    'businesses': businesses,
  };
}

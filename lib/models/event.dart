import 'package:cnect/models/location.dart';

class Event {
  // Create model variables
  String id;
  String name;
  String description;
  DateTime startTime;
  DateTime endTime;
  LocationData location;
  String community;

  Event({
    this.id,
    this.name,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.community,
  });

// Convert JSON to data model variables
  Event.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    // Convert JSON string date into DateTime
    startTime = DateTime.parse(data['start_time']);
    endTime = DateTime.parse(data['end_time']);
    // Convert JSON into variable with the LocationData
    location = new LocationData.fromJson(data['location']);
    community = data['community'];
  }

  // Convert data model variables to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
    'location': location.toJson(),
    'community': community
  };
}

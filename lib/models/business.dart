import 'package:cnect/models/announcement.dart';
import 'package:cnect/models/event.dart';
import 'package:cnect/models/location.dart';

class Business {
  // Create model variables
  String id;
  String name;
  String description;
  LocationData location;
  List<Event> events;
  List<Announcement> announcements;

  Business({
    this.id,
    this.name,
    this.description,
    this.location,
    this.events,
    this.announcements,
  });

  // Convert JSON to data model variables
  Business.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    location = new LocationData.fromJson(data['location']);
    // Map a JSON array to list of objects
    events = data['events'] != []
        ? data['events'].map((item) => Event.fromJson(item)).toList().cast<Event>()
        : new List<Event>();
    announcements = data['announcements'] != []
        ? data['announcements'].map((item) => Announcement.fromJson(item)).toList().cast<Announcement>()
        : new List<Announcement>();
  }

  // Convert data model variables to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'location': location.toJson(),
  };
}

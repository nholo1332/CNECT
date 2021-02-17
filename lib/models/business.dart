import 'package:cnect/models/event.dart';
import 'package:cnect/models/location.dart';

class Business {
  String id;
  String name;
  String description;
  LocationData location;
  List<Event> events;

  Business({
    this.id,
    this.name,
    this.description,
    this.location,
    this.events,
  });

  Business.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    location = new LocationData.fromJson(data['location']);
    events = data['events'] != []
        ? data['events'].map((item) => Event.fromJson(item)).toList().cast<Event>()
        : new List<Event>();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'location': location.toJson(),
  };
}

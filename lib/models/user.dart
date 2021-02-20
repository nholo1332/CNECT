import 'package:cnect/models/community.dart';
import 'package:cnect/models/event.dart';

class UserClass {
  // Create model variables
  String name;
  String description;
  List<Community> communities;
  List<Event> events;
  List<String> businesses;
  List<String> followedBusinesses;

  UserClass({
    this.name,
    this.description,
    this.communities,
    this.events,
    this.businesses,
    this.followedBusinesses,
  });

  // Convert JSON to data model variables
  UserClass.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    description = data['description'];
    communities = data['communities'] != []
        ? data['communities'].map((item) => Community.fromJson(item)).toList().cast<Community>()
        : new List<Community>();
    events = data['events'] != []
        ? data['events'].map((item) => Event.fromJson(item)).toList().cast<Event>()
        : new List<Event>();
    businesses = new List<String>.from(data['businesses']);
    followedBusinesses = new List<String>.from(data['followed_businesses']);
  }

  // Convert data model variables to JSON. We only need to convert the name
  // property as this method is only called during sign up
  Map<String, dynamic> toJson() => {
    'name': name,
  };
}

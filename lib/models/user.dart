import 'package:cnect/models/community.dart';
import 'package:cnect/models/event.dart';

class UserClass {
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

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}

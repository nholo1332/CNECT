import 'package:cnect/models/community.dart';
import 'package:cnect/models/event.dart';

class UserClass {
  String name;
  List<Community> communities;
  List<Event> events;
  List<String> businesses;

  UserClass({
    this.name,
    this.communities,
    this.events,
    this.businesses,
  });

  UserClass.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    communities = data['communities'] != []
        ? data['communities'].map((item) => Community.fromJson(item)).toList().cast<Community>()
        : new List<Community>();
    events = data['events'] != []
        ? data['events'].map((item) => Event.fromJson(item)).toList().cast<Event>()
        : new List<Event>();
    businesses = new List<String>.from(data['businesses']);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}

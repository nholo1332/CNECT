class UserClass {
  String name;
  List<String> communities;
  List<String> events;
  List<String> businesses;

  UserClass({
    this.name,
    this.communities,
    this.events,
    this.businesses,
  });

  UserClass.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    communities = data['communities'];
    events = data['events'];
    businesses = data['businesses'];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'communities': communities,
    'events': events,
    'businesses': businesses
  };
}

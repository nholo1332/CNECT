class Event {
  String id;
  String name;
  String description;
  DateTime startTime;
  DateTime endTime;
  String location;
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

  Event.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    startTime = DateTime.parse(data['start_time']);
    endTime = DateTime.parse(data['end_time']);
    location = data['location'];
    community = data['community'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
    'location': location,
    'community': community
  };
}

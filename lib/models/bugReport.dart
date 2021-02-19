class BugReport {
  String location;
  String description;
  String steps;
  String deviceInfo;

  BugReport({
    this.location,
    this.description,
    this.steps,
    this.deviceInfo,
  });

  BugReport.fromJson(Map<String, dynamic> data) {
    location = data['location'];
    description = data['description'];
    steps = data['steps'];
    deviceInfo = data['device_info'];
  }

  Map<String, dynamic> toJson() => {
    'location': location,
    'description': description,
    'steps': steps,
    'device_info': deviceInfo,
  };
}

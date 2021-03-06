class Announcement {
  // Create model variables
  String id;
  String title;
  String description;
  String url;
  DateTime publishDate;

  Announcement({
    this.id,
    this.title,
    this.description,
    this.url,
    this.publishDate,
  });

  // Convert JSON to data model variables
  Announcement.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    url = data['url'];
    publishDate = DateTime.parse(data['publish_date']);
  }

  // Convert data model variables to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'url': url,
    'publish_date': publishDate.toIso8601String(),
  };
}

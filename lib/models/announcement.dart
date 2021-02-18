class Announcement {
  String id;
  String name;
  String description;
  String url;
  DateTime publishDate;

  Announcement({
    this.id,
    this.name,
    this.description,
    this.url,
    this.publishDate,
  });

  Announcement.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    url = data['url'];
    publishDate = DateTime.parse(data['publish_date']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'url': url,
    'publish_date': publishDate.toIso8601String(),
  };
}

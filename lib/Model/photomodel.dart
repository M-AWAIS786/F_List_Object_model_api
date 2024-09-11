class Photo {
  final int id;
  final String url;
  final String title;

  Photo({required this.url, required this.title, required this.id});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      url: json['url'],
      title: json['title'],
      id: json['id'],
    );
  }
}

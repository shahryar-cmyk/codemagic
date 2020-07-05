class Business {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String guid;
  final String image;

  Business(
      {this.id, this.title, this.content, this.excerpt, this.guid, this.image});
  factory Business.fromJson(Map<String, dynamic> json) {
    String image = json['featured_image']["large"] != ""
        ? json['custom']["featured_image"]
        : "https://images.wallpaperscraft.com/image/surface_dark_background_texture_50754_1920x1080.jpg";
    return Business(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        excerpt: json["excerpt"],
        guid: json["guid"],
        image: image);
  }

  //Problem occur possible
  factory Business.fromDatabaseJson(Map<String, dynamic> data) => Business(
        id: data['id'],
        title: data['title'],
        content: data['content'],
        image: data['image'],
        excerpt: data['excerpt'],
        guid: data['guid'],
      );
  Map<String, dynamic> toDatabaseJson() => {
        'id': this.id,
        'title': this.title,
        'content': this.content,
        'image': this.image,
        'excerpt': this.excerpt,
        'guid': this.guid,
      };
}

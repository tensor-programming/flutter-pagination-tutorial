class Photo {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.id, this.title, this.url, this.thumbnailUrl, this.albumId});

  Photo.fromJson(Map json)
      : this.id = json["id"],
        this.albumId = json["albumId"],
        this.title = json["title"],
        this.url = json["url"],
        this.thumbnailUrl = json["thumbnailUrl"];
}

class Artist {
  String? name;
  String? profileImageUrl;
  String? artistId;

  Artist({this.name, this.profileImageUrl, this.artistId});

  static Artist fromJson(Map<String, dynamic> json) {
    return Artist(
        name: json['name'],
        profileImageUrl: json['profileImageUrl'],
        artistId: json["objectID"]);
  }
}

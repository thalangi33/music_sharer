class Song {
  String? songTitle;
  String? artist;
  String? artistId;
  String? songImageUrl;
  String? songUrl;

  Song(
      {this.songTitle,
      this.artist,
      this.artistId,
      this.songImageUrl,
      this.songUrl});

  void addData(songTitle, artist, artistId, songImageUrl, songUrl) {
    this.songTitle = songTitle;
    this.artist = artist;
    this.artistId = artistId;
    this.songImageUrl = songImageUrl;
    this.songUrl = songUrl;
  }

  static Song fromJson(Map<String, dynamic> json) {
    return Song(
        artist: json['artist'],
        artistId: json['artistId'],
        songTitle: json['songTitle'],
        songImageUrl: json["songImageUrl"],
        songUrl: json["songUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "artist": artist,
      "artistId": artistId,
      "songTitle": songTitle,
      "songImageUrl": songImageUrl,
      "songUrl": songUrl,
    };
  }
}

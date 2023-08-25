import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/pages/playlist_page.dart';
import 'package:music_sharer/shared/constants.dart';

class LibraryPlaylistTile extends StatelessWidget {
  LibraryPlaylistTile(
      {super.key,
      required this.playlist,
      this.playlistIndex,
      required this.likedSongsFlag});
  final Map playlist;
  int? playlistIndex;

  final bool likedSongsFlag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaylistPage(
                      playlistIndex: playlistIndex,
                      likedSongsFlag: likedSongsFlag,
                    )));
      },
      child: Row(
        children: [
          Image.network(
            likedSongsFlag
                ? playlist["playlistImage"]
                : (playlist["songs"].length != 0
                    ? playlist["songs"][0].songImageUrl
                    : emptyPlaylistImage),
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                likedSongsFlag ? "Liked songs" : playlist["playlistTitle"],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text("2022")
            ],
          )
        ],
      ),
    );
    ;
  }
}

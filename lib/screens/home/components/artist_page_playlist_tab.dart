import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/components/playlist_tile.dart';

class ArtistPagePlaylistTab extends StatelessWidget {
  const ArtistPagePlaylistTab(
      {super.key,
      required this.artist,
      required this.featuredPlaylist,
      required this.artistPlaylist});
  final String artist;
  final List featuredPlaylist;
  final List artistPlaylist;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        SizedBox(
          height: 20,
        ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Featuring $artist",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              )),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 160,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 15,
              );
            },
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: featuredPlaylist.length,
            itemBuilder: (context, index) {
              return PlaylistTile(
                playlistTitle: featuredPlaylist[index]["playlistTitle"],
                playlistImageUrl: featuredPlaylist[index]["playlistImageUrl"],
              );
            },
          ),
        ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Playlists made by $artist",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              )),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 160,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 15,
              );
            },
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: artistPlaylist.length,
            itemBuilder: (context, index) {
              return PlaylistTile(
                playlistTitle: artistPlaylist[index]["playlistTitle"],
                playlistImageUrl: artistPlaylist[index]["playlistImageUrl"],
              );
            },
          ),
        ),
      ],
    );
  }
}

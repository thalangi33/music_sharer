import 'package:flutter/material.dart';
import 'package:music_sharer/models/song.dart';
import 'package:music_sharer/screens/home/components/song_tile.dart';
import 'package:music_sharer/screens/home/components/top_tracks_tile.dart';

class TopTracksList extends StatelessWidget {
  const TopTracksList({super.key, required this.trackList, required this.callback});

  final List trackList;
  final Function() callback;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: trackList.length,
          itemBuilder: (context, index) {
            print("This is tracklist[] ${trackList[index]}");
            return SongTile(
              index: 0,
              song: Song(
                  artist: trackList[index]["artist"],
                  artistId: trackList[index]["artistId"],
                  songTitle: trackList[index]["songTitle"],
                  songImageUrl: trackList[index]["songImageUrl"],
                  songUrl: trackList[index]["songUrl"]),
              searchFlag: false,
              playlistFlag: false,
              callback: callback
            );
            // return TopTracksTile(
            //     index: index,
            //     songTitle: trackList[index]["songTitle"],
            //     songImageUrl: trackList[index]["songImageUrl"]);
          }),
    );
  }
}

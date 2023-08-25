import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:music_sharer/models/song.dart';
import 'package:music_sharer/provider/music_provider.dart';
import 'package:music_sharer/screens/home/components/album_list.dart';
import 'package:music_sharer/screens/home/components/top_tracks_list.dart';
import 'package:music_sharer/services/database.dart';
import 'package:music_sharer/shared/circle_button.dart';
import 'package:provider/provider.dart';

class ArtistPageMusicTab extends StatefulWidget {
  const ArtistPageMusicTab(
      {super.key,
      required this.artistId,
      required this.topTracks,
      required this.albums});
  final String artistId;
  final List topTracks;
  final List albums;

  @override
  State<ArtistPageMusicTab> createState() => _ArtistPageMusicTabState();
}

class _ArtistPageMusicTabState extends State<ArtistPageMusicTab> {
  bool hideShowMoreTracksButton = false;
  late List example;
  late List example2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    example = widget.topTracks.slice(0, 5);
    example2 = widget.topTracks.slice(5);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // shrinkWrap: true,
      padding: EdgeInsets.only(top: 0),
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Top tracks",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              Spacer(),
              CircleButton(
                onTap: () async {
                  List<Song> playlist = await DatabaseService()
                      .getPopularTracks(widget.artistId ?? "");

                  print(playlist);
                  print(playlist[1].songTitle);

                  if (context.mounted) {
                    Provider.of<MusicProvider>(context, listen: false)
                        .setAvailableSongs(playlist);

                    Provider.of<MusicProvider>(context, listen: false)
                        .changeSong(
                            playlist[0],
                            playlist.indexWhere((chosenSong) =>
                                chosenSong.songTitle == playlist[0].songTitle &&
                                chosenSong.artist == playlist[0].artist));
                  }
                },
                icon: Icon(
                  Icons.play_arrow,
                  size: 50,
                ),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                splashColor: Colors.transparent.withOpacity(0.01),
                height: 50,
                width: 50,
              ),
            ],
          ),
        ),
        TopTracksList(
          trackList: example,
          callback: () {
            setState(() {});
          },
        ),
        hideShowMoreTracksButton == false
            ? SizedBox(
                height: 25,
                child: Align(
                  child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          example = example + example2;
                          hideShowMoreTracksButton = true;
                          print(widget.topTracks.length);
                        });
                      },
                      child: Text("More tracks")),
                ))
            : SizedBox(),
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              "Albums",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: AlbumList(albums: widget.albums)),
        widget.albums.length > 4
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                    height: 25,
                    child: Align(
                        child: OutlinedButton(
                            onPressed: () {}, child: Text("More albums")))),
              )
            : SizedBox(),
      ],
    );
  }
}

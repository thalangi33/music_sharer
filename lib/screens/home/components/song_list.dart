import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/components/song_tile.dart';
import 'package:music_sharer/services/database.dart';
import 'package:music_sharer/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:music_sharer/models/song.dart';

import '../../../provider/music_provider.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  @override
  Widget build(BuildContext context) {
    print("Loading songs");
    return FutureBuilder(
      future: DatabaseService().getAllSongs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<MusicProvider>(context, listen: false)
              .setAvailableSongs(snapshot.data ?? []);

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return SongTile(
                index: index,
                song: snapshot.data![index],
                searchFlag: false,
                playlistFlag: false,
                callback: () {
                  setState(() {});
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("Error");
        } else {
          return Loading();
        }
      },
    );
  }
}

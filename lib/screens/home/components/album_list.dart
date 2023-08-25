import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/components/album_tile.dart';

class AlbumList extends StatelessWidget {
  const AlbumList({super.key, required this.albums});
  final List albums;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 12);
          },
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: albums.length,
          itemBuilder: (context, index) {
            return AlbumTile(
              albumTitle: albums[index]["albumTitle"],
              albumImageUrl: albums[index]["albumImageUrl"],
            );
          }),
    );
  }
}

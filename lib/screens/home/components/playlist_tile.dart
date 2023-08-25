import 'package:flutter/material.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile(
      {super.key, required this.playlistImageUrl, required this.playlistTitle});
  final String playlistImageUrl;
  final String playlistTitle;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.network(
        playlistImageUrl,
        height: 110,
        width: 110,
        fit: BoxFit.cover,
      ),
      SizedBox(
        height: 3,
      ),
      Container(
        width: 110,
        child: Text(
          playlistTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }
}

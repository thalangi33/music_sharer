import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/components/playlist_tile.dart';

import '../../../services/auth.dart';
import '../components/song_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    List<int> example = [1, 1, 1, 1, 1];

    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(
              "Home",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            actions: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text("Logout"),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ],
          ),
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("All songs",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ))),
                ),
                SizedBox(
                  height: 15,
                ),
                SongList(),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text("Recently played",
                //         style: TextStyle(
                //           fontSize: 24,
                //           fontWeight: FontWeight.w700,
                //         ))),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   height: 160,
                //   child: ListView.separated(
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 15,
                //       );
                //     },
                //     // shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: example.length,
                //     itemBuilder: (context, index) {
                //       return PlaylistTile(
                //         playlistImageUrl:
                //             "https://firebasestorage.googleapis.com/v0/b/music-sharer-6bc5b.appspot.com/o/playlist_images%2FRed%20Velvet%20artist%20playlist%20image.jpg?alt=media&token=beb02900-5fe7-4e0c-9f83-483c8f935438",
                //         playlistTitle: "Red Velvet Official Playlist",
                //       );
                //     },
                //   ),
                // ),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text("Mixes from your recent listens",
                //         style: TextStyle(
                //           fontSize: 24,
                //           fontWeight: FontWeight.w700,
                //         ))),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   height: 160,
                //   child: ListView.separated(
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 15,
                //       );
                //     },
                //     // shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: example.length,
                //     itemBuilder: (context, index) {
                //       return PlaylistTile(
                //         playlistImageUrl:
                //             "https://firebasestorage.googleapis.com/v0/b/music-sharer-6bc5b.appspot.com/o/playlist_images%2FRed%20Velvet%20artist%20playlist%20image.jpg?alt=media&token=beb02900-5fe7-4e0c-9f83-483c8f935438",
                //         playlistTitle: "Red Velvet Official Playlist",
                //       );
                //     },
                //   ),
                // ),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text("Mixes from your favourite artists",
                //         style: TextStyle(
                //           fontSize: 24,
                //           fontWeight: FontWeight.w700,
                //         ))),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   height: 160,
                //   child: ListView.separated(
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 15,
                //       );
                //     },
                //     // shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: example.length,
                //     itemBuilder: (context, index) {
                //       return PlaylistTile(
                //         playlistImageUrl:
                //             "https://firebasestorage.googleapis.com/v0/b/music-sharer-6bc5b.appspot.com/o/playlist_images%2FRed%20Velvet%20artist%20playlist%20image.jpg?alt=media&token=beb02900-5fe7-4e0c-9f83-483c8f935438",
                //         playlistTitle: "Red Velvet Official Playlist",
                //       );
                //     },
                //   ),
                // ),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text("Mixes from your likes",
                //         style: TextStyle(
                //           fontSize: 24,
                //           fontWeight: FontWeight.w700,
                //         ))),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   height: 160,
                //   child: ListView.separated(
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 15,
                //       );
                //     },
                //     // shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: example.length,
                //     itemBuilder: (context, index) {
                //       return PlaylistTile(
                //         playlistImageUrl:
                //             "https://firebasestorage.googleapis.com/v0/b/music-sharer-6bc5b.appspot.com/o/playlist_images%2FRed%20Velvet%20artist%20playlist%20image.jpg?alt=media&token=beb02900-5fe7-4e0c-9f83-483c8f935438",
                //         playlistTitle: "Red Velvet Official Playlist",
                //       );
                //     },
                //   ),
                // ),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text("What's trending",
                //         style: TextStyle(
                //           fontSize: 24,
                //           fontWeight: FontWeight.w700,
                //         ))),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   height: 160,
                //   child: ListView.separated(
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: 15,
                //       );
                //     },
                //     // shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: example.length,
                //     itemBuilder: (context, index) {
                //       return PlaylistTile(
                //         playlistImageUrl:
                //             "https://firebasestorage.googleapis.com/v0/b/music-sharer-6bc5b.appspot.com/o/playlist_images%2FRed%20Velvet%20artist%20playlist%20image.jpg?alt=media&token=beb02900-5fe7-4e0c-9f83-483c8f935438",
                //         playlistTitle: "Red Velvet Official Playlist",
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

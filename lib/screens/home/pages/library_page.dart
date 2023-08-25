import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/components/album_tile.dart';
import 'package:music_sharer/screens/home/components/top_tracks_list.dart';
import 'package:music_sharer/screens/home/components/library_playlist_tile.dart';
import 'package:music_sharer/services/database.dart';
import 'package:music_sharer/shared/loading.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final playlistTitleController = TextEditingController();

  @override
  void dispose() {
    playlistTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder(
          future: DatabaseService().getLibraryInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text("Your library",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Playlists",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 200,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            icon: Icon(Icons.close),
                                            splashRadius: 25,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Create a playlist",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          Spacer(),
                                          FilledButton(
                                              onPressed: () async {
                                                Map playlist = {
                                                  "playlistTitle":
                                                      playlistTitleController
                                                          .text,
                                                  "songs": []
                                                };
                                                await DatabaseService()
                                                    .createPlaylist(playlist);
                                                Navigator.pop(context);
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                setState(() {});
                                              },
                                              child: Text(
                                                "Create",
                                                style: TextStyle(fontSize: 16),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Playlist name",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: TextField(
                                            controller: playlistTitleController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                            ),
                                            autofocus: true,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.add))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LibraryPlaylistTile(
                    playlist: snapshot.data!["likedSongs"],
                    likedSongsFlag: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!["playlists"].length,
                    itemBuilder: (context, index) {
                      return LibraryPlaylistTile(
                        playlistIndex: index,
                        playlist: snapshot.data!["playlists"][index],
                        likedSongsFlag: false,
                      );
                    },
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  //   child: SizedBox(
                  //       height: 25,
                  //       child: Align(
                  //           child: OutlinedButton(
                  //               onPressed: () {}, child: Text("Show more")))),
                  // ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Favorite artists",
                  //       style: TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //     Spacer(),
                  //     Visibility(
                  //         visible: false,
                  //         maintainSize: true,
                  //         maintainAnimation: true,
                  //         maintainState: true,
                  //         child: IconButton(
                  //             onPressed: () {}, icon: Icon(Icons.add)))
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // ListView.separated(
                  //   separatorBuilder: (context, index) {
                  //     return SizedBox(
                  //       height: 10,
                  //     );
                  //   },
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemCount: snapshot.data!["playlists"].length,
                  //   itemBuilder: (context, index) {
                  //     return LibraryPlaylistTile(
                  //       playlist: snapshot.data!["playlists"][index],
                  //       likedSongsFlag: false,
                  //     );
                  //   },
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  //   child: SizedBox(
                  //       height: 25,
                  //       child: Align(
                  //           child: OutlinedButton(
                  //               onPressed: () {}, child: Text("Show more")))),
                  // )
                ],
              );
            } else if (snapshot.hasError) {
              return Text("Error");
            } else {
              return Loading();
            }
          },
        ),
      ),
    ));
  }
}

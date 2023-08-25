import 'package:flutter/material.dart';
import 'package:music_sharer/models/song.dart';
import 'package:music_sharer/provider/music_provider.dart';
import 'package:music_sharer/services/database.dart';
import 'package:music_sharer/shared/constants.dart';
import 'package:music_sharer/shared/loading.dart';
import 'package:music_sharer/shared/snackbar_content.dart';
import 'package:provider/provider.dart';

class SongTile extends StatefulWidget {
  final Song song;
  final int index;
  final bool searchFlag;
  final bool playlistFlag;
  List<Song>? playlist;
  final Function() callback;
  int? playlistIndex;
  SongTile(
      {super.key,
      required this.index,
      required this.song,
      required this.searchFlag,
      required this.playlistFlag,
      this.playlist,
      required this.callback,
      this.playlistIndex});

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, value, child) {
        return ListTile(
            onTap: () async {
              // Provider.of<MusicProvider>(context, listen: false)
              //     .changeSong(song, index);

              if (widget.playlistFlag == false) {
                List<Song> playlist = await DatabaseService()
                    .getPopularTracks(widget.song.artistId ?? "");

                if (context.mounted) {
                  Provider.of<MusicProvider>(context, listen: false)
                      .setAvailableSongs(playlist);

                  Provider.of<MusicProvider>(context, listen: false).changeSong(
                      widget.song,
                      playlist.indexWhere((chosenSong) =>
                          chosenSong.songTitle == widget.song.songTitle &&
                          chosenSong.artist == widget.song.artist));
                }
              } else {
                Provider.of<MusicProvider>(context, listen: false)
                    .setAvailableSongs(widget.playlist ?? []);
                Provider.of<MusicProvider>(context, listen: false).changeSong(
                    widget.song,
                    widget.playlist!.indexWhere((chosenSong) =>
                        chosenSong.songTitle == widget.song.songTitle &&
                        chosenSong.artist == widget.song.artist));
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            tileColor: Theme.of(context).colorScheme.background,
            contentPadding:
                EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
            leading: Image.network(widget.song.songImageUrl ?? ""),
            title: Text(
              widget.song.songTitle ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: widget.searchFlag
                ? Text("Song")
                : Text(widget.song.artist ?? ""),
            trailing: IconButton(
                onPressed: () {
                  optionsModal(context);
                },
                icon: Icon(Icons.more_vert))
            // Icon(Icons.more_vert),
            );
      },
    );
  }

  Future<dynamic> optionsModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        FocusManager.instance.primaryFocus?.unfocus();
        // bool alreadyLiked = value.userInfo["likedSongs"]["songs"]
        //     .any((likedSong) =>
        //         likedSong["songTitle"] == widget.song.songTitle &&
        //         likedSong["artist"] == widget.song.artist);

        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder(
              future: DatabaseService().getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool alreadyLiked = snapshot.data["likedSongs"]["songs"].any(
                      (likedSong) =>
                          likedSong["songTitle"] == widget.song.songTitle &&
                          likedSong["artist"] == widget.song.artist);

                  return Container(
                    height: widget.playlistFlag ? 250 : 200,
                    child: Column(children: [
                      ListTile(
                        leading: Image.network(widget.song.songImageUrl ?? ""),
                        title: Text(
                          widget.song.songTitle ?? "",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        contentPadding: EdgeInsets.only(
                            top: 10, bottom: 0, left: 10, right: 10),
                      ),
                      Divider(),
                      GestureDetector(
                        onTap: () async {
                          await DatabaseService()
                              .likeSong(widget.song, alreadyLiked);
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: CustomSnackBarContent(
                              message: !alreadyLiked
                                  ? "Added to liked songs"
                                  : "Removed from liked songs",
                            ),
                            behavior: SnackBarBehavior.floating,
                          ));
                          widget.callback();

                          // Map userInfo = await DatabaseService()
                          //     .likeSong(value.userInfo["userId"],
                          //         widget.song, alreadyLiked);
                          // Provider.of<MusicProvider>(context,
                          //         listen: false)
                          //     .setUserInfo(userInfo);
                          // widget.callback;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                alreadyLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Like",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          addToPlaylistModal(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.add,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Add to playlist",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ),
                      widget.playlistFlag
                          ? GestureDetector(
                              onTap: () async {
                                await DatabaseService().removeSongToPlaylist(
                                    widget.song, widget.playlistIndex ?? 0);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomSnackBarContent(
                                    message: "Removed from playlist",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ));

                                widget.callback();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.remove_circle_outline_sharp,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Remove from this playlist",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                    ]),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error");
                } else {
                  return Container(height: 200, child: Loading());
                }
              },
            );
          },
        );
      },
    );
  }

  Future<dynamic> addToPlaylistModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder(
              future: DatabaseService().getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 500,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: Text("Add to playlist",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data["playlists"].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await DatabaseService()
                                    .addSongToPlaylist(widget.song, index);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomSnackBarContent(
                                    message: "Added to playlist",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                widget.callback();
                                // widget
                                //     .callback;
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Row(
                                  children: [
                                    Image.network(
                                      snapshot.data["playlists"][index]["songs"]
                                                  .length !=
                                              0
                                          ? snapshot.data["playlists"][index]
                                              ["songs"][0]["songImageUrl"]
                                          : emptyPlaylistImage,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data["playlists"][index]
                                              ["playlistTitle"],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text("2022")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ]),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error");
                } else {
                  // return Loading();
                  return SizedBox();
                }
              },
            );
          },
        );
      },
    );
  }
}

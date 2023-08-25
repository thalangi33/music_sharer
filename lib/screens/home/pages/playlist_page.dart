import 'package:flutter/material.dart';
import 'package:music_sharer/provider/music_provider.dart';
import 'package:music_sharer/screens/home/pages/library_page.dart';
import 'package:music_sharer/screens/home/components/song_list.dart';
import 'package:music_sharer/screens/home/components/song_tile.dart';
import 'package:music_sharer/services/database.dart';
import 'package:music_sharer/shared/circle_button.dart';
import 'package:music_sharer/shared/constants.dart';
import 'package:music_sharer/shared/loading.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatefulWidget {
  PlaylistPage({
    super.key,
    this.playlistIndex,
    required this.likedSongsFlag,
  });
  int? playlistIndex;
  final bool likedSongsFlag;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
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
        child: Stack(
          children: [
            Align(
              child: FutureBuilder(
                future: DatabaseService().getLibraryInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map playlist = {};

                    if (widget.likedSongsFlag == true) {
                      playlist = snapshot.data!["likedSongs"];
                    } else {
                      playlist = snapshot.data!["playlists"]
                          [widget.playlistIndex ?? 0];
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Image.network(
                          widget.likedSongsFlag
                              ? playlist["playlistImage"]
                              : (playlist["songs"].length != 0
                                  ? playlist["songs"][0].songImageUrl
                                  : emptyPlaylistImage),
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                            widget.likedSongsFlag
                                ? "Liked songs"
                                : playlist["playlistTitle"],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              !widget.likedSongsFlag
                                  ? IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 200,
                                              child: Column(children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 5),
                                                  child: Row(
                                                    children: [
                                                      Image.network(
                                                        playlist["songs"]
                                                                    .length !=
                                                                0
                                                            ? playlist["songs"]
                                                                    [0]
                                                                .songImageUrl
                                                            : emptyPlaylistImage,
                                                        height: 60,
                                                        width: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      SizedBox(width: 12),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            playlist[
                                                                "playlistTitle"],
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Text("2022")
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        playlistTitleController
                                                                .text =
                                                            playlist[
                                                                "playlistTitle"];
                                                        return Container(
                                                          height: 150,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .close),
                                                                      splashRadius:
                                                                          25,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Text(
                                                                      "Edit playlist",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    Spacer(),
                                                                    FilledButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await DatabaseService().editPlaylistTitle(
                                                                              playlistTitleController.text,
                                                                              widget.playlistIndex ?? 0);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Save",
                                                                          style:
                                                                              TextStyle(fontSize: 16),
                                                                        ))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            24),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          playlistTitleController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                0,
                                                                            vertical:
                                                                                5),
                                                                      ),
                                                                      autofocus:
                                                                          true,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.black),
                                                                    )),
                                                              ]),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons.edit,
                                                          size: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("Edit playlist",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await DatabaseService()
                                                        .deletePlaylist(widget
                                                                .playlistIndex ??
                                                            0);
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LibraryPage()),
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons.close,
                                                          size: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("Delete playlist",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.more_vert))
                                  : SizedBox(),
                              Spacer(),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.shuffle)),
                              CircleButton(
                                onTap: () {
                                  Provider.of<MusicProvider>(context,
                                          listen: false)
                                      .setAvailableSongs(
                                          playlist["songs"] ?? []);

                                  Provider.of<MusicProvider>(context,
                                          listen: false)
                                      .changeSong(
                                          playlist["songs"][0],
                                          playlist["songs"].indexWhere(
                                              (chosenSong) =>
                                                  chosenSong.songTitle ==
                                                      playlist["songs"][0]
                                                          .songTitle &&
                                                  chosenSong.artist ==
                                                      playlist["songs"][0]
                                                          .artist));
                                },
                                icon: Icon(Icons.play_arrow),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                                splashColor:
                                    Colors.transparent.withOpacity(0.01),
                                height: 50,
                                width: 50,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: playlist["songs"].length,
                              itemBuilder: (context, index) {
                                return SongTile(
                                  index: index,
                                  song: playlist["songs"][index],
                                  searchFlag: false,
                                  playlistFlag: true,
                                  playlist: playlist["songs"],
                                  callback: () {
                                    print("Callback is called");
                                    setState(() {});
                                  },
                                  playlistIndex: widget.playlistIndex,
                                );
                              },
                            ))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    // return Loading();
                    return SizedBox();
                  }
                },
              ),
            ),
            SizedBox(
              height: 65,
              child: AppBar(
                toolbarHeight: 65,
                leading: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LibraryPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 32.0,
                    ),
                    shape: CircleBorder(),
                    fillColor: Colors.transparent.withOpacity(0.15),
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    splashColor: Colors.transparent.withOpacity(0.001),
                  ),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

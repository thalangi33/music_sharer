import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/components/library_playlist_tile.dart';

class LibraryPagePlaylistView extends StatefulWidget {
  const LibraryPagePlaylistView({super.key});

  @override
  State<LibraryPagePlaylistView> createState() =>
      _LibraryPagePlaylistViewState();
}

class _LibraryPagePlaylistViewState extends State<LibraryPagePlaylistView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            toolbarHeight: 65,
            title: Text(
              "Playlists",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
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
                                    onPressed: () {},
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
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: TextField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
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
                icon: Icon(Icons.add),
                color: Colors.black,
              )
            ],
            leading: Container(
              margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: RawMaterialButton(
                onPressed: () {},
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
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
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
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    // return LibraryPlaylistTile();
                    return SizedBox();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

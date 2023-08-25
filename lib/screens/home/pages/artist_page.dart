import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_sharer/screens/home/components/album_list.dart';
import 'package:music_sharer/screens/home/components/artist_page_about_tab.dart';
import 'package:music_sharer/screens/home/components/artist_page_menu_buttons.dart';
import 'package:music_sharer/screens/home/components/artist_page_music_tab.dart';
import 'package:music_sharer/screens/home/components/artist_page_playlist_tab.dart';
import 'package:music_sharer/screens/home/components/top_tracks_list.dart';

import 'package:music_sharer/services/database.dart';
import 'package:music_sharer/shared/loading.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key, required this.artistId});
  final String artistId;
  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _index);
  }

  // final List<Widget> _tabs = [
  //   ArtistPageMusicTab(),
  //   ArtistPagePlaylistTab(),
  //   ArtistPageAboutTab()
  // ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: DefaultTabController(
        animationDuration: Duration.zero,
        length: 3,
        child: SafeArea(
            top: false,
            child: FutureBuilder(
                future: DatabaseService().getArtistInfo(widget.artistId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              primary: false,
                              toolbarHeight: 300,
                              flexibleSpace: Stack(children: [
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter),
                                      image: DecorationImage(
                                        // colorFilter:
                                        //     ColorFilter.mode(Colors.white, BlendMode.src),
                                        alignment: Alignment.topCenter,
                                        // image: AssetImage(
                                        //   "assets/Red Velvet - Bad Boy.jpg",
                                        // ),
                                        image: NetworkImage(
                                            snapshot.data["profileImageUrl"]),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                IgnorePointer(
                                  child: Container(
                                    height: 300,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(.8),
                                            Colors.transparent
                                          ],
                                          stops: [
                                            0,
                                            0.6,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    AppBar(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      // leading: IconButton(
                                      //     onPressed: () {},
                                      //     icon: Icon(Icons.arrow_back,
                                      //         color: Colors.white)),
                                    ),
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            snapshot.data["name"],
                                            style: TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              Colors.transparent,
                                              BlendMode.difference,
                                            ),
                                            child: ArtistPageMenuTab(
                                              callback: (int newIndex) {
                                                setState(() {
                                                  _index = newIndex;
                                                  // _tabController.animateTo(newIndex);
                                                  DefaultTabController.of(
                                                          context)
                                                      .animateTo(newIndex);
                                                });
                                              },
                                            ))),
                                  ],
                                ),
                              ]),
                              pinned: false,
                              floating: false,
                              snap: false,
                              forceElevated: innerBoxIsScrolled,
                            )
                          ];
                        },
                        body: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            // controller: _tabController,
                            children: [
                              ArtistPageMusicTab(
                                artistId: widget.artistId,
                                topTracks: snapshot.data["popularTracks"],
                                albums: snapshot.data["albums"],
                              ),
                              ArtistPagePlaylistTab(
                                artist: snapshot.data["name"],
                                featuredPlaylist:
                                    snapshot.data["featuredPlaylist"],
                                artistPlaylist: snapshot.data["artistPlaylist"],
                              ),
                              ArtistPageAboutTab(
                                  monthlyListeners:
                                      snapshot.data["monthlyListeners"],
                                  followers: snapshot.data["followers"],
                                  bio: snapshot.data["bio"])
                            ]));
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    return Loading();
                  }
                })),
      ),
    );
  }
}

// class _ArtistPageState extends State<ArtistPage>
//     with SingleTickerProviderStateMixin {
//   int _index = 0;
//   late ScrollController _scrollController;
//   late TabController _tabController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _scrollController = ScrollController();
//     _tabController =
//         TabController(length: 3, vsync: this, initialIndex: _index);
//   }

//   final List<Widget> _tabs = [
//     ArtistPageMusicTab(),
//     ArtistPagePlaylistTab(),
//     ArtistPageAboutTab()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle(
//           statusBarColor: Colors.transparent,
//         ),
//         child: SafeArea(
//           top: false,
//           child: SingleChildScrollView(
//             child: Column(children: [
//               Stack(children: [
//                 Container(
//                   height: 300,
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           colors: [Colors.black, Colors.transparent],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter),
//                       image: DecorationImage(
//                         alignment: Alignment.topCenter,
//                         image: AssetImage(
//                           "assets/Red Velvet - Bad Boy.jpg",
//                         ),
//                         fit: BoxFit.cover,
//                       )),
//                   child: Column(
//                     children: [
//                       AppBar(
//                         backgroundColor: Colors.transparent,
//                         shadowColor: Colors.transparent,
//                         leading: IconButton(
//                             onPressed: () {},
//                             icon: Icon(Icons.arrow_back, color: Colors.white)),
//                       ),
//                       SizedBox(
//                         height: 60,
//                       ),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Container(
//                           margin: EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                             "Red Velvet",
//                             style: TextStyle(
//                                 fontSize: 50,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                           margin: EdgeInsets.symmetric(horizontal: 16),
//                           child: ColorFiltered(
//                               colorFilter: const ColorFilter.mode(
//                                 Colors.transparent,
//                                 BlendMode.difference,
//                               ),
//                               child: ArtistPageMenuTab(
//                                 callback: (int newIndex) {
//                                   setState(() {
//                                     _index = newIndex;
//                                     // _tabController.animateTo(newIndex);
//                                     // DefaultTabController.of(context)
//                                     //     .animateTo(newIndex);
//                                   });
//                                 },
//                               ))),
//                     ],
//                   ),
//                 ),
//                 IgnorePointer(
//                   child: Container(
//                     height: 300,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           colors: [
//                             Colors.black.withOpacity(.8),
//                             Colors.transparent
//                           ],
//                           stops: [
//                             0,
//                             0.1,
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter),
//                     ),
//                   ),
//                 )
//               ]),
//               IndexedStack(
//                 index: _index,
//                 children: _tabs,
//               )
//             ]),
//           ),
//         ));
//   }
// }

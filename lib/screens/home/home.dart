import 'package:flutter/material.dart';
import 'package:music_sharer/models/song.dart';
import 'package:music_sharer/provider/music_provider.dart';
import 'package:music_sharer/screens/home/components/audio_player.dart';
import 'package:music_sharer/screens/home/pages/library_page.dart';
import 'package:music_sharer/screens/home/pages/main_page.dart';
import 'package:music_sharer/screens/home/pages/search_page.dart';
import 'package:music_sharer/screens/home/pages/settings_page.dart';
import 'package:music_sharer/screens/home/tab_navigator.dart';
import 'package:music_sharer/services/auth.dart';
import 'package:music_sharer/services/database.dart';
import 'package:music_sharer/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:music_sharer/screens/home/components/song_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  Song song = Song();

  String _currentPage = "Home";

  List<String> pageKeys = ["Home", "Search", "Library", "Settings"];

  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "Search": GlobalKey<NavigatorState>(),
    "Library": GlobalKey<NavigatorState>(),
    "Settings": GlobalKey<NavigatorState>(),
  };

  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doSomeAsyncStuff();
  }

  Future<void> doSomeAsyncStuff() async {
    Provider.of<MusicProvider>(context, listen: false)
        .setUserInfo(await DatabaseService().getUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    Song song = context.watch<MusicProvider>().chosenSong;

    return FutureBuilder(
      future: DatabaseService().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Widget home loaded");

          return WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
                  !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
              if (isFirstRouteInCurrentTab) {
                if (_currentPage != "Home") {
                  _selectTab("Home", 1);

                  return false;
                }
              }
              // let system handle back button if we're on the first route
              return isFirstRouteInCurrentTab;
            },
            child: Scaffold(
              extendBodyBehindAppBar: true,
              body: Stack(children: <Widget>[
                _buildOffstageNavigator("Home"),
                _buildOffstageNavigator("Search"),
                _buildOffstageNavigator("Library"),
                _buildOffstageNavigator("Settings"),
              ]),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  song.songTitle != null
                      ? AudioPlayerWidget()
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  BottomNavigationBar(
                      currentIndex: _selectedIndex,
                      onTap: (int index) {
                        _selectTab(pageKeys[index], index);
                        setState(() {});
                        // Navigator.pop(context);
                        _navigatorKeys[pageKeys[index]]!
                            .currentState!
                            .pushNamedAndRemoveUntil(pageKeys[index],
                                (Route<dynamic> route) => false);
                      },
                      selectedItemColor: Theme.of(context).colorScheme.primary,
                      unselectedItemColor:
                          Theme.of(context).colorScheme.secondary,
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.search),
                          label: 'Search',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.music_note),
                          label: 'Library',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: 'Settings',
                        ),
                      ]),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error");
        } else {
          // return Loading();
          return Container(
            color: Theme.of(context).colorScheme.background,
          );
        }
      },
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem] ?? GlobalKey<NavigatorState>(),
        tabItem: tabItem,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/pages/artist_page.dart';
import 'package:music_sharer/screens/home/pages/library_page.dart';
import 'package:music_sharer/screens/home/pages/library_page_playlist_view.dart';
import 'package:music_sharer/screens/home/pages/main_page.dart';
import 'package:music_sharer/screens/home/pages/playlist_page.dart';
import 'package:music_sharer/screens/home/pages/search_page.dart';
import 'package:music_sharer/screens/home/pages/search_view.dart';
import 'package:music_sharer/screens/home/pages/settings_page.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child = MainPage();
    if (tabItem == "Home")
      child = MainPage();
    else if (tabItem == "Search")
      child = SearchPage();
    else if (tabItem == "Library")
      child = LibraryPage();
    else if (tabItem == "Settings") child = SettingsPage();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => child,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },
    );
  }
}

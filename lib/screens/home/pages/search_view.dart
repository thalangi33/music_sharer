import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:music_sharer/models/artist.dart';
import 'package:music_sharer/models/song.dart';
import 'package:music_sharer/screens/home/components/artist_tile.dart';
import 'package:music_sharer/screens/home/components/song_tile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuerySuggestion {
  QuerySuggestion(this.query, this.highlighted);

  String query;
  HighlightedString? highlighted;

  static QuerySuggestion fromJson(Hit hit) {
    final highlighted = hit.getHighlightedString('query', inverted: true);
    return QuerySuggestion(hit["query"], highlighted);
  }

  @override
  String toString() => query;
}

/// Query suggestions data repository.
class SongSuggestionRepository {
  /// Hits Searcher for suggestions index
  final _suggestionsSearcher = HitsSearcher(
      applicationID: dotenv.env['APPLICATION_ID'] ?? "",
      apiKey: dotenv.env['ALGOLIA_API_KEY'] ?? "",
      indexName: 'songs');

  /// Get query suggestions for a given query string.
  void query(String query) {
    _suggestionsSearcher.query(query);
  }

  /// Get query suggestions stream
  late final Stream<List<Song>> suggestions = _suggestionsSearcher.responses
      .map((response) => response.hits.map(Song.fromJson).toList());

  /// Dispose of underlying resources.
  void dispose() {
    _suggestionsSearcher.dispose();
  }
}

class ArtistSuggestionRepository {
  /// Hits Searcher for suggestions index
  final _suggestionsSearcher = HitsSearcher(
      applicationID: dotenv.env['APPLICATION_ID'] ?? "",
      apiKey: dotenv.env['ALGOLIA_API_KEY'] ?? "",
      indexName: 'artists');

  /// Get query suggestions for a given query string.
  void query(String query) {
    _suggestionsSearcher.query(query);
  }

  /// Get query suggestions stream
  late final Stream<List<Artist>> suggestions = _suggestionsSearcher.responses
      .map((response) => response.hits.map(Artist.fromJson).toList());

  /// Dispose of underlying resources.
  void dispose() {
    _suggestionsSearcher.dispose();
  }
}

// class SearchMetadata {
//   final int nbHits;

//   const SearchMetadata(this.nbHits);

//   factory SearchMetadata.fromResponse(SearchResponse response) =>
//       SearchMetadata(response.nbHits);
// }

// class Song {
//   final String artist;
//   final String songTitle;
//   final String songImageUrl;

//   Song(this.artist, this.songTitle, this.songImageUrl);

//   static Song fromJson(Map<String, dynamic> json) {
//     return Song(
//         json['artist'], json['songTitle'], json["songImageUrl"]);
//   }
// }

// class HitsPage {
//   const HitsPage(this.items, this.pageKey, this.nextPageKey);

//   final List<Song> items;
//   final int pageKey;
//   final int? nextPageKey;

//   factory HitsPage.fromResponse(SearchResponse response) {
//     final items = response.hits.map(Song.fromJson).toList();
//     final isLastPage = response.page >= response.nbPages;
//     final nextPageKey = isLastPage ? null : response.page + 1;
//     return HitsPage(items, response.page, nextPageKey);
//   }
// }

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchTextController = TextEditingController();

  FocusNode searchBarFocusNode = FocusNode();
  final songSuggestionRepository = SongSuggestionRepository();
  final artistSuggestionRepository = ArtistSuggestionRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchBarFocusNode.requestFocus();

    _searchTextController.addListener(() {
      songSuggestionRepository._suggestionsSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
        ),
      );

      artistSuggestionRepository._suggestionsSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
        ),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    // _songsSearcher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            pinned: true,
            titleSpacing: 0,
            elevation: 0,
            flexibleSpace: SearchBar(
              controller: _searchTextController,
              onChanged: (query) {
                songSuggestionRepository.query(query);
                artistSuggestionRepository.query(query);
              },
              focusNode: searchBarFocusNode,
              hintText: "Search songs, artists or playlist",
              shape: MaterialStateProperty.all(RoundedRectangleBorder()),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primaryContainer),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 10,
          )),
          _searchTextController.text != ""
              ? _sectionBody(
                  context,
                  artistSuggestionRepository.suggestions,
                  (Artist artist) => ArtistTile(
                        artist: artist,
                        searchFlag: true,
                      ))
              : SliverToBoxAdapter(
                  child: SizedBox(),
                ),
          _searchTextController.text != ""
              ? _sectionBody(
                  context,
                  songSuggestionRepository.suggestions,
                  (Song song) => SongTile(
                        index: 0,
                        song: song,
                        searchFlag: true,
                        playlistFlag: false,
                        callback: () {
                          setState(() {});
                        },
                      ))
              : SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(50, 200, 50, 0),
                    child: Text(
                      'Find songs, artists or playlists that you want to listen',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ]),
        //     child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     SearchBar(
        //       controller: _searchTextController,
        //       onChanged: SongsuggestionRepository.query,
        //       focusNode: searchBarFocusNode,
        //       hintText: "Search songs, artists or playlist",
        //       shape: MaterialStateProperty.all(RoundedRectangleBorder()),
        //       elevation: MaterialStateProperty.all<double>(0),
        //       backgroundColor: MaterialStateProperty.all<Color>(
        //           Theme.of(context).colorScheme.primaryContainer),
        //       leading: IconButton(
        //           icon: Icon(Icons.arrow_back),
        //           onPressed: () => Navigator.pop(context)),
        //     ),
        //     SizedBox(
        //       height: MediaQuery.of(context).size.height / 3,
        //     ),
        //     // StreamBuilder<SearchMetadata>(
        //     //   stream: _searchMetadata,
        //     //   builder: (context, snapshot) {
        //     //     if (!snapshot.hasData) {
        //     //       return const SizedBox.shrink();
        //     //     }
        //     //     return Padding(
        //     //       padding: const EdgeInsets.all(8.0),
        //     //       child: Text('${snapshot.data!.nbHits} hits'),
        //     //     );
        //     //   },
        //     // ),
        //     Container(
        //       margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
        //       child: Text(
        //         'Find songs, artists or playlists that you want to listen',
        //         style: TextStyle(fontSize: 16),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //     // Expanded(child: _hits(context))
        //     _sectionBody(context, SongsuggestionRepository.suggestions, (Song item) => SongTile(index: 0, song: item))
        //   ],
        // )
      ),
    );
  }

  // Widget _hits(BuildContext context) => PagedListView<int, Song>(
  //     pagingController: _pagingController,
  //     builderDelegate: PagedChildBuilderDelegate<Song>(
  //         noItemsFoundIndicatorBuilder: (_) => const Center(
  //               child: Text('No results found'),
  //             ),
  //         itemBuilder: (_, item, __) => Container(
  //               color: Colors.white,
  //               height: 80,
  //               padding: const EdgeInsets.all(8),
  //               // child: Row(
  //               //   children: [
  //               //     SizedBox(
  //               //         width: 50, child: Image.network(item.songImageUrl)),
  //               //     const SizedBox(width: 20),
  //               //     Expanded(child: Text(item.songTitle))
  //               //   ],
  //               // ),
  //               child: SongTile(index: 0, song: item),
  //             )));

  Widget _sectionBody<Item>(
    BuildContext context,
    Stream<List<Item>> itemsStream,
    Function(Item) rowBuilder,
  ) =>
      StreamBuilder<List<Item>>(
          stream: itemsStream,
          builder: (context, snapshot) {
            final suggestions = snapshot.data ?? [];
            if (suggestions.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            return SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  sliver: SliverList(
                      // itemExtent: 70,
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final item = suggestions[index];
                      return InkWell(
                          onTap: () {
                            final query = item.toString();
                            // _onSubmitSearch(query, context);
                          },
                          child: rowBuilder(item));
                    },
                    childCount: suggestions.length,
                  )),
                ));
          });
}

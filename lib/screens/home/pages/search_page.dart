import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:music_sharer/screens/home/pages/search_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void methodA() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> tags = [
      "What's popular?",
      "What's trending?",
      "Charts",
      "Pop",
      "Indie",
      "Hip-hop",
      "Jazz",
      "Classical",
      "Folk",
      "Chill"
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Search",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchView()));
                  // Navigator.push(context, SearchView());
                },
                child: AbsorbPointer(
                  child: SearchBar(
                    hintText: "Search songs, artists or playlist",
                    shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primaryContainer),
                    leading: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.5,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  return Card(
                      color: Theme.of(context).colorScheme.surfaceTint,
                      elevation: 0,
                      child: Center(
                          child: Text(
                        tags[index],
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      )));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

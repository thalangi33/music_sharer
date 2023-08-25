import 'package:flutter/material.dart';
import 'package:music_sharer/models/artist.dart';
import 'package:music_sharer/screens/home/pages/artist_page.dart';

class ArtistTile extends StatelessWidget {
  const ArtistTile({
    super.key,
    required this.artist,
    required this.searchFlag,
  });
  final Artist artist;
  final bool searchFlag;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      tileColor: Theme.of(context).colorScheme.background,
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
      leading: CircleAvatar(
          radius: 28.0,
          backgroundImage: NetworkImage(artist.profileImageUrl ?? "")),
      title: Text(
        artist.name ?? "",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: searchFlag ? Text("Artist") : SizedBox(),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArtistPage(
                      artistId: artist.artistId ?? "",
                    )));
      },
    );
  }
}

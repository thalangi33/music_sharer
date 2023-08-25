import 'package:flutter/material.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile(
      {super.key, required this.albumImageUrl, required this.albumTitle});
  final String albumImageUrl;
  final String albumTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          albumImageUrl,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 130,
              child: Text(
                albumTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text("2022")
          ],
        )
      ],
    );
    // return ListTile(
    //   onTap: () {
    //     print("Hello 123");
    //   },
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    //   tileColor: Theme.of(context).colorScheme.background,
    //   contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
    //   leading: Image.asset(
    //     "assets/Red Velvet - Bad Boy.jpg",
    //     height: 100,
    //     width: 100,
    //     fit: BoxFit.cover,
    //   ),
    //   title: Text(
    //     "Album",
    //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    //   ),
    //   subtitle: Text("2022"),
    //   visualDensity: VisualDensity(vertical: 4),
    // );
  }
}

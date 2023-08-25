import 'package:flutter/material.dart';

class TopTracksTile extends StatelessWidget {
  const TopTracksTile(
      {super.key,
      required this.index,
      required this.songTitle,
      required this.songImageUrl});
  final int index;
  final String songTitle;
  final String songImageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print("Hello 123");
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      tileColor: Theme.of(context).colorScheme.background,
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 10),
      leading: SizedBox(
        width: 90,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                (index + 1).toString(),
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            Image.network(
              songImageUrl,
              width: 50,
            )
          ],
        ),
      ),
      minLeadingWidth: 45,
      title: Text(
        songTitle,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text("123"),
      trailing: Icon(Icons.more_vert),
    );
  }
}

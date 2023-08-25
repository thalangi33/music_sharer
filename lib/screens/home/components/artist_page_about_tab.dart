import 'package:flutter/material.dart';

class ArtistPageAboutTab extends StatelessWidget {
  const ArtistPageAboutTab(
      {super.key,
      required this.monthlyListeners,
      required this.followers,
      required this.bio});
  final int monthlyListeners;
  final int followers;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "Monthly listeners".toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          monthlyListeners.toString().replaceAllMapped(
              RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},"),
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Followers".toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          followers.toString().replaceAllMapped(
              RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},"),
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Bio",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          bio,
          style: TextStyle(
            fontSize: 18,
          ),
        )
      ],
    );
  }
}

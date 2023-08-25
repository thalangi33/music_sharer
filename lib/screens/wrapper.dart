import 'package:flutter/material.dart';
import 'package:music_sharer/models/myUser.dart';
import 'package:music_sharer/provider/music_provider.dart';
import 'package:music_sharer/screens/authenticate/authenticate.dart';
import 'package:music_sharer/screens/home/home.dart';
import 'package:music_sharer/screens/home/components/music_detail.dart';
import 'package:music_sharer/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
      // child: MusicDetail(),
    }
  }
}

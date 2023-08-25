import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/song.dart';

class MusicProvider with ChangeNotifier {

  Map _userInfo = {};
  Map get userInfo => _userInfo;

  Song _chosenSong = Song();
  Song get chosenSong => _chosenSong;

  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;

  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);
  ConcatenatingAudioSource get playlist => _playlist;

  Future<void> changeSong(Song chosenSong, int index) async {
    try {
      _chosenSong = chosenSong;

      await _audioPlayer.dispose();
      _audioPlayer = AudioPlayer()
        ..stop
        ..setAudioSource(_playlist, initialIndex: index)
        ..setLoopMode(LoopMode.all)
        ..play();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setAvailableSongs(List<Song> avaialbleSongs) {
    _playlist = ConcatenatingAudioSource(children: []);

    avaialbleSongs.asMap().forEach((int index, Song song) {
      _playlist.add(AudioSource.uri(Uri.parse(song.songUrl ?? ""),
          tag: MediaItem(
              id: index.toString(),
              title: song.songTitle ?? "",
              artist: song.artist ?? "",
              artUri: Uri.parse(song.songImageUrl ?? ""))));
    });

    print("add playlist success");
  }

  void setUserInfo(userInfo){
    _userInfo = userInfo;
    notifyListeners();
  }
}

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_sharer/models/song.dart';
import 'package:music_sharer/provider/music_provider.dart';
import 'package:music_sharer/screens/home/components/music_detail.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/positionData.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  final _playlist = ConcatenatingAudioSource(children: []);

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPositionStream, duration) => PositionData(
              position, bufferedPositionStream, duration ?? Duration.zero));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.song.songTitle);
    // print(widget.song.songUrl);
    // print("weqe");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Disposing audio player");
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (context, musicProvider, child) {
      _audioPlayer = musicProvider.audioPlayer;
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MusicDetail()));
        },
        child: Column(children: [
          StreamBuilder(
            stream: _audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return SizedBox();
              }
              final metadata = state!.currentSource!.tag as MediaItem;
              return ListTile(
                // leading:
                //     Image.network(musicProvider.chosenSong.songImageUrl ?? ""),
                leading: CachedNetworkImage(
                  imageUrl: metadata.artUri.toString(),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  metadata.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(metadata.artist ?? ""),
                trailing: Control(audioPlayer: _audioPlayer),
                tileColor: Theme.of(context).colorScheme.background,
              );
            },
          ),
          // ListTile(
          //   leading: Image.network(musicProvider.chosenSong.songImageUrl ?? ""),
          //   title: Text(
          //     musicProvider.chosenSong.songTitle ?? "",
          //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //   ),
          //   subtitle: Text(musicProvider.chosenSong.artist ?? ""),
          //   trailing: Control(audioPlayer: _audioPlayer),
          //   tileColor: Theme.of(context).colorScheme.background,
          // ),
          StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  color: Theme.of(context).colorScheme.background,
                  child: ProgressBar(
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                  ),
                );
              }),
        ]),
      );
      return Column(
        children: [
          StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              }),
          Control(audioPlayer: _audioPlayer)
        ],
      );
    });
  }
}

class Control extends StatelessWidget {
  const Control({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (!(playing ?? false)) {
            return IconButton(
                onPressed: audioPlayer.play,
                icon: Icon(Icons.play_arrow_rounded));
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
                onPressed: audioPlayer.pause, icon: Icon(Icons.pause_rounded));
          }
          return Icon(Icons.play_arrow_rounded);
        });
  }
}

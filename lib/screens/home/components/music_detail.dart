import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/positionData.dart';
import '../../../models/song.dart';
import '../../../provider/music_provider.dart';

class MusicDetail extends StatefulWidget {
  const MusicDetail({super.key});

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail> {
  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPositionStream, duration) => PositionData(
              position, bufferedPositionStream, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (context, musicProvider, child) {
      _audioPlayer = musicProvider.audioPlayer;
      Song song = musicProvider.chosenSong;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Now playing",
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined)),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream: _audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return SizedBox();
                    }
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return Column(
                      children: [
                        SizedBox(
                          height: 35,
                        ),
                        Center(
                            child: CachedNetworkImage(
                          imageUrl: metadata.artUri.toString(),
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        )),
                        SizedBox(
                          height: 35,
                        ),
                        Text(
                          metadata.title,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          metadata.artist ?? "",
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }),
              StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      color: Theme.of(context).colorScheme.background,
                      child: ProgressBar(
                        progress: positionData?.position ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: _audioPlayer.seek,
                      ),
                    );
                  }),
              Control(audioPlayer: _audioPlayer, function: () {}),
            ]),
      );
    });
  }
}

class Control extends StatelessWidget {
  const Control({super.key, required this.audioPlayer, required this.function});

  final AudioPlayer audioPlayer;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: audioPlayer.seekToPrevious,
            icon: Icon(
              Icons.skip_previous_rounded,
              size: 70,
            )),
        StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (!(playing ?? false)) {
                return IconButton(
                    onPressed: audioPlayer.play,
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 70,
                    ));
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: audioPlayer.pause,
                    icon: Icon(
                      Icons.pause_rounded,
                      size: 70,
                    ));
              }
              return Icon(
                Icons.play_arrow_rounded,
                size: 70,
              );
            }),
        IconButton(
            onPressed: audioPlayer.seekToNext,
            icon: Icon(
              Icons.skip_next_outlined,
              size: 70,
            )),
      ],
    );
  }
}

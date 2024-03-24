import 'package:flutter/material.dart';
import 'package:video_player_win/video_player_win.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late final WinVideoPlayerController _videoController;
  @override
  Widget build(BuildContext context) {
    return WinVideoPlayer(_videoController);
  }
}

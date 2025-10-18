import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HorizontalVideo extends StatefulWidget {
  const HorizontalVideo({super.key});

  @override
  State<HorizontalVideo> createState() => _HorizontalVideoState();
}

class _HorizontalVideoState extends State<HorizontalVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // 播放本地 asset 视频
    _controller = VideoPlayerController.asset("assets/video/horizontal.mp4",
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  return Center(
    child: ClipRRect(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(
              color: Colors.white, // 占位背景
              width: double.infinity,
              height: 250, // 你想要的高度
            ),
    ),
  );
}
}

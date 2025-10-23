import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OnboardingVideo extends StatefulWidget {
  final VoidCallback? onVideoEnd; // ✅ 视频播放完后的回调

  const OnboardingVideo({super.key, this.onVideoEnd});

  @override
  State<OnboardingVideo> createState() => OnboardingVideoState();
}

class OnboardingVideoState extends State<OnboardingVideo> {
  late VideoPlayerController _controller;
  bool _isEnded = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      "assets/video/en.mp4",
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });

    // ✅ 监听播放结束
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_isEnded &&
          _controller.value.isInitialized) {
        setState(() {
          _isEnded = true;
        });
        widget.onVideoEnd?.call();
      }
    });
  }

  void reloadVideo() async {
    await _controller.pause();
    await _controller.seekTo(Duration.zero);
    setState(() {
      _isEnded = false;
    });
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ 视频区域
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                  color: Colors.black12,
                  width: double.infinity,
                  height: 500,
                ),
        ),

      ],
    );
  }
}


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;
import 'package:chewie/chewie.dart';

class CustomVideoPlayerController extends GetxController {
  vp.VideoPlayerController? _videoController;
  ChewieController? chewieController;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  vp.VideoPlayerController get videoController => _videoController!;

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Dispose existing controllers if they exist
      if (chewieController != null) {
        chewieController!.dispose();
        chewieController = null;
      }
      if (_videoController != null) {
        await _videoController!.dispose();
        _videoController = null;
      }

      // Using a more reliable test video URL
      final videoUrl =
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

      _videoController = vp.VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      // Wait for initialization
      await _videoController!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Video initialization timed out');
        },
      );

      // Create Chewie Controller only if video initialization was successful
      if (_videoController!.value.isInitialized) {
        chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoController!.value.aspectRatio,
          placeholder: const Center(child: CircularProgressIndicator()),
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Get.theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          },
        );
        isLoading.value = false;
      } else {
        throw Exception('Failed to initialize video player');
      }
    } catch (error) {
      hasError.value = true;
      errorMessage.value = error.toString();
      isLoading.value = false;
      debugPrint('Video Player Error: $error');
    }
  }

  void togglePlay() {
    if (_videoController?.value.isInitialized != true) return;
    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
  }

  void seekTo(Duration position) {
    if (_videoController?.value.isInitialized != true) return;
    _videoController!.seekTo(position);
  }

  @override
  void onClose() {
    _videoController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}

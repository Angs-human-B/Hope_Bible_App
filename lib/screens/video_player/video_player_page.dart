import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'controllers/video_player.controller.dart';

class VideoPlayerPage extends GetView<CustomVideoPlayerController> {
  const VideoPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary initialization - remove this once routing is properly set up
    if (!Get.isRegistered<CustomVideoPlayerController>()) {
      Get.put(CustomVideoPlayerController());
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Video Player'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.refresh),
          onPressed: () => controller.initializePlayer(),
        ),
      ),
      child: SafeArea(
        child: Obx(
          () =>
              controller.isLoading.value
                  ? const Center(child: CupertinoActivityIndicator())
                  : controller.hasError.value
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.exclamationmark_triangle,
                          color: CupertinoColors.destructiveRed,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: CupertinoColors.destructiveRed,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        CupertinoButton(
                          onPressed: controller.initializePlayer,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                  : controller.chewieController != null
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio:
                              controller.videoController.value.aspectRatio,
                          child: Chewie(
                            controller: controller.chewieController!,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Custom controls (optional, since Chewie provides its own)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Obx(
                                () => Icon(
                                  controller.videoController.value.isPlaying
                                      ? CupertinoIcons.pause
                                      : CupertinoIcons.play,
                                ),
                              ),
                              onPressed: controller.togglePlay,
                            ),
                            // Add more custom controls here if needed
                          ],
                        ),
                      ],
                    ),
                  )
                  : const Center(
                    child: Text(
                      'Failed to load video player',
                      style: TextStyle(color: CupertinoColors.label),
                    ),
                  ),
        ),
      ),
    );
  }
}

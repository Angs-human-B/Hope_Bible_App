import 'package:get/get.dart';
import '../controllers/video_player.controller.dart';

class VideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomVideoPlayerController>(
      () => CustomVideoPlayerController(),
    );
  }
}

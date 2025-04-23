import 'package:get/get.dart';
import '../screens/video_player/video_player_page.dart';
import '../screens/video_player/bindings/video_player.binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.VIDEO_PLAYER,
      page: () => const VideoPlayerPage(),
      binding: VideoPlayerBinding(),
    ),
    // ... other routes ...
  ];
}

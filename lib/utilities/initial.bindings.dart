import 'package:get/get.dart';
import '../media/controllers/media.controller.dart' show MediaController;
import '../screens/auth/controllers/user.auth.controller.dart'
    show SignUpController;
import '../screens/bible/controllers/bible.controller.dart'
    show BibleController;
import '../screens/chat/controllers/chat.controller.dart' show ChatController;
import '../screens/onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
import '../services/favorites_service.dart' show FavoritesController;
import '../streak/controllers/streak.controller.dart' show StreakController;
import 'language.utility.dart' show LanguageController;

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => BibleController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => LanguageController());
    Get.lazyPut(() => OnboardingController(totalPages: 11));
    Get.lazyPut(() => StreakController());
    Get.lazyPut(() => MediaController());
    Get.lazyPut(() => FavoritesController());
  }
}

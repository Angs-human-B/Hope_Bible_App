import 'package:get/get.dart';

import '../screens/auth/controllers/user.auth.controller.dart'
    show SignUpController;
import '../screens/bible/controllers/bible.controller.dart'
    show BibleController;
import '../screens/chat/controllers/chat.controller.dart' show ChatController;
import '../screens/onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
import 'language.utility.dart' show LanguageController;

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => BibleController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => LanguageController());
    Get.lazyPut(() => OnboardingController(totalPages: 11));
  }
}

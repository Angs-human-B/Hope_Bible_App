import 'package:get/get.dart';

import '../screens/bible/controllers/bible.controller.dart'
    show BibleController;

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BibleController());
  }
}

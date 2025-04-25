import 'package:get/get.dart';
import 'package:hope/utilities/app.constants.dart' show Utils;
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  // Observable to store the selected language code
  RxString tranlsatedText = ''.obs;

  var selectedLanguage = 'en'.obs;

  // Key for storing the language in SharedPreferences
  final String languageKey = 'selected_language';

  @override
  void onInit() {
    super.onInit();
    _loadLanguageFromPrefs();
  }

  // Function to update the selected language and save to SharedPreferences
  Future<void> updateLanguage(String newLanguage) async {
    selectedLanguage.value = newLanguage;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, newLanguage);
    Utils.logger.i('Language saved: $newLanguage'); // Debug print
    update();
  }

  // Load the selected language from SharedPreferences or default to 'en'
  Future<void> _loadLanguageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString(languageKey);

    if (savedLanguage != null) {
      selectedLanguage.value = savedLanguage;
    } else {
      selectedLanguage.value = 'en'; // Default language
    }

    update();
  }
}

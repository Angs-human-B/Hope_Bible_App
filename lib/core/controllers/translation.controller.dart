import 'package:get/get.dart';
import 'package:google_cloud_translation/google_cloud_translation.dart';

class TranslationController extends GetxController {
  final _translation = Translation(apiKey: 'YOUR_API_KEY');
  final RxString currentLanguage = 'en'.obs;
  final RxBool isTranslating = false.obs;

  // Cache for translations
  final _cache = <String, Map<String, String>>{};

  // Supported languages
  final List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
  ];

  Future<String> translateText(String text) async {
    if (currentLanguage.value == 'en') return text;

    // Check cache first
    if (_cache[currentLanguage.value]?[text] != null) {
      return _cache[currentLanguage.value]![text]!;
    }

    try {
      isTranslating(true);
      final result = await _translation.translate(
        text: text,
        to: currentLanguage.value,
      );

      // Cache the result
      _cache[currentLanguage.value] ??= {};
      _cache[currentLanguage.value]![text] = result.translatedText;

      return result.translatedText;
    } catch (e) {
      print('Translation error: $e');
      return text;
    } finally {
      isTranslating(false);
    }
  }

  Future<void> changeLanguage(String langCode) async {
    if (currentLanguage.value == langCode) return;
    currentLanguage.value = langCode;
  }

  String getLanguageName(String code) {
    final lang = supportedLanguages.firstWhere(
      (l) => l['code'] == code,
      orElse: () => {'code': code, 'name': code, 'nativeName': code},
    );
    return lang['nativeName']!;
  }
}

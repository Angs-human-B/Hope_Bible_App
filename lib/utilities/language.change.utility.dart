import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hope/screens/language_screen.dart';
import 'language.utility.dart' show LanguageController;

class LanguageChangeUtility {
  static final languageController = Get.find<LanguageController>();

  static void showLanguageScreen(BuildContext context) {
    // Ensure the controller is initialized
    if (!Get.isRegistered<LanguageController>()) {
      Get.put(LanguageController());
    }

    Navigator.of(
      context,
    ).push(CupertinoPageRoute(builder: (context) => const LanguageScreen()));
  }

  // Helper methods to get the selected flag and language name based on selectedLanguage
  static String get selectedFlag {
    switch (languageController.selectedLanguage.value) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      case 'pt':
        return '🇵🇹';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'it':
        return '🇮🇹';
      case 'ja':
        return '🇯🇵';
      case 'ko':
        return '🇰🇷';
      case 'ru':
        return '🇷🇺';
      case 'ar':
        return '🇸🇦';
      case 'hi':
        return '🇮🇳';
      case 'bn':
        return '🇧🇩';
      case 'vi':
        return '🇻🇳';
      case 'tr':
        return '🇹🇷';
      case 'nl':
        return '🇳🇱';
      case 'sv':
        return '🇸🇪';
      case 'pl':
        return '🇵🇱';
      case 'id':
        return '🇮🇩';
      case 'th':
        return '🇹🇭';
      case 'he':
        return '🇮🇱';
      case 'da':
        return '🇩🇰';
      case 'fi':
        return '🇫🇮';
      case 'no':
        return '🇳🇴';
      case 'ro':
        return '🇷🇴';
      case 'hu':
        return '🇭🇺';
      case 'cs':
        return '🇨🇿';
      case 'el':
        return '🇬🇷';
      case 'uk':
        return '🇺🇦';
      case 'ms':
        return '🇲🇾';
      case 'sk':
        return '🇸🇰';
      case 'hr':
        return '🇭🇷';
      case 'sr':
        return '🇷🇸';
      case 'bg':
        return '🇧🇬';
      case 'lt':
        return '🇱🇹';
      case 'lv':
        return '🇱🇻';
      case 'et':
        return '🇪🇪';
      case 'sl':
        return '🇸🇮';
      case 'mt':
        return '🇲🇹';
      case 'ga':
        return '🇮🇪';
      case 'is':
        return '🇮🇸';
      default:
        return '🇺🇸';
    }
  }

  static String get selectedLanguageName {
    switch (languageController.selectedLanguage.value) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Português';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'ru':
        return 'Русский';
      case 'ar':
        return 'العربية';
      case 'hi':
        return 'हिन्दी';
      case 'bn':
        return 'বাংলা';
      case 'vi':
        return 'Tiếng Việt';
      case 'tr':
        return 'Türkçe';
      case 'nl':
        return 'Nederlands';
      case 'sv':
        return 'Svenska';
      case 'pl':
        return 'Polski';
      case 'id':
        return 'Bahasa Indonesia';
      case 'th':
        return 'ไทย';
      case 'he':
        return 'עברית';
      case 'da':
        return 'Dansk';
      case 'fi':
        return 'Suomi';
      case 'no':
        return 'Norsk';
      case 'ro':
        return 'Română';
      case 'hu':
        return 'Magyar';
      case 'cs':
        return 'Čeština';
      case 'el':
        return 'Ελληνικά';
      case 'uk':
        return 'Українська';
      case 'ms':
        return 'Bahasa Melayu';
      case 'sk':
        return 'Slovenčina';
      case 'hr':
        return 'Hrvatski';
      case 'sr':
        return 'Српски';
      case 'bg':
        return 'Български';
      case 'lt':
        return 'Lietuvių';
      case 'lv':
        return 'Latviešu';
      case 'et':
        return 'Eesti';
      case 'sl':
        return 'Slovenščina';
      case 'mt':
        return 'Malti';
      case 'ga':
        return 'Gaeilge';
      case 'is':
        return 'Íslenska';
      default:
        return 'English';
    }
  }
}

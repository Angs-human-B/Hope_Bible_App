import 'dart:math' show Random;

import 'package:flutter/cupertino.dart' show GlobalKey, State, StringCharacters;
import 'package:logger/logger.dart';

abstract class EntitleMents {
  static const String entitlementId = "bible.premium";

  static const String footerText = "Example Footer Text for Yum AI";

  static const String appleApiKey = "appl_EvCvhLitTnqdZNjbCIxwWmtlFPY";

  static const String googleApiKey = "goog_DoJkUjrGoyhbhMqknjGkckySIkq";
}

abstract class AppConstants {
  static bool seenOneTimeOffer = false;
  static String influencerCode = '';
  static double yearlyPrice = 2.99;
  static bool provisioned = false;
  static bool showButton = true;
  static bool showFreeTrial = false;
  static String revenueCatId = '';
  static int freePaywall = 0;
  static bool isSubscriptionActive = false;
  static bool existingUser = false;
  static String currentSubscription = '';
  static bool eligibleForTrial = true;
  static String myCurrency = '';
  static String currencySymbol = '';
  static String appVersion = "";
  static String remoteVersion = "";
  static const String appName = "RecipeIt";
  static String authToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NzcyMWRhMTY2NmMyZWZkNDc0N2NiZDciLCJyb2xlIjoidXNlciIsImVtYWlsIjoiYWthc2gzNEBibGVzc2ZpLmNvbSIsImlhdCI6MTczNzYwMzgxOCwiZXhwIjoxNzM4NDY3ODE4fQ.pYCgJrAmeBsM-ICeJw6cKxPdV11f0CNc9zN4pF_RunQ";
  static String userId = "67fd3c3f41f72e24bfc41114";
  static String name = "";
  static String username = "";
  static String email = "";
  static String readingTime = "";
  static String appleId = "";
  static String googleId = "";
  static int stringLimit = 50;
  static GlobalKey<State> globalKey = GlobalKey();
  static bool showWelcomeScreen = false;
  static bool isMale = true;
}

abstract class BaseUrl {
  static String url = "https://hope-backend-repo.onrender.com/";
  // https://recipeit-dev-582786b38486.herokuapp.com   https://yumaipipeline-3cc427dc62c5.herokuapp.com/ https://bc6a-142-115-90-76.ngrok-free.app
}

abstract class Language {
  static final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
    {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'bn', 'name': 'বাংলা', 'flag': '🇧🇩'},
    {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'nl', 'name': 'Nederlands', 'flag': '🇳🇱'},
    {'code': 'sv', 'name': 'Svenska', 'flag': '🇸🇪'},
    {'code': 'pl', 'name': 'Polski', 'flag': '🇵🇱'},
    {'code': 'id', 'name': 'Bahasa Indonesia', 'flag': '🇮🇩'},
    {'code': 'th', 'name': 'ไทย', 'flag': '🇹🇭'},
    {'code': 'he', 'name': 'עברית', 'flag': '🇮🇱'},
    {'code': 'da', 'name': 'Dansk', 'flag': '🇩🇰'},
    {'code': 'fi', 'name': 'Suomi', 'flag': '🇫🇮'},
    {'code': 'no', 'name': 'Norsk', 'flag': '🇳🇴'},
    {'code': 'ro', 'name': 'Română', 'flag': '🇷🇴'},
    {'code': 'hu', 'name': 'Magyar', 'flag': '🇭🇺'},
    {'code': 'cs', 'name': 'Čeština', 'flag': '🇨🇿'},
    {'code': 'el', 'name': 'Ελληνικά', 'flag': '🇬🇷'},
    {'code': 'uk', 'name': 'Українська', 'flag': '🇺🇦'},
    {'code': 'ms', 'name': 'Bahasa Melayu', 'flag': '🇲🇾'},
    {'code': 'sk', 'name': 'Slovenčina', 'flag': '🇸🇰'},
    {'code': 'hr', 'name': 'Hrvatski', 'flag': '🇭🇷'},
    {'code': 'sr', 'name': 'Српски', 'flag': '🇷🇸'},
    {'code': 'bg', 'name': 'Български', 'flag': '🇧🇬'},
    {'code': 'lt', 'name': 'Lietuvių', 'flag': '🇱🇹'},
    {'code': 'lv', 'name': 'Latviešu', 'flag': '🇱🇻'},
    {'code': 'et', 'name': 'Eesti', 'flag': '🇪🇪'},
    {'code': 'sl', 'name': 'Slovenščina', 'flag': '🇸🇮'},
    {'code': 'mt', 'name': 'Malti', 'flag': '🇲🇹'},
    {'code': 'ga', 'name': 'Gaeilge', 'flag': '🇮🇪'},
    {'code': 'is', 'name': 'Íslenska', 'flag': '🇮🇸'},
  ];
}

class Utils {
  static Logger logger = Logger(printer: PrettyPrinter());
  static String makeid(length) {
    String result = '';
    String characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    int charactersLength = characters.length;
    for (int i = 0; i < length; i++) {
      result += characters.characters.elementAt(
        Random().nextInt(charactersLength),
      );
    }
    return result;
  }
}

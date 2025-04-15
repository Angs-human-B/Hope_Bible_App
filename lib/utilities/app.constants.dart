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
  static String userId = "67721da1666c2efd4747cbd7";
  static String name = "";
  static String username = "";
  static String email = "";
  static String appleId = "";
  static String googleId = "";
  static int stringLimit = 50;
  static GlobalKey<State> globalKey = GlobalKey();
  static bool showWelcomeScreen = false;
}

abstract class BaseUrl {
  static String url = "https://51d4-70-31-58-126.ngrok-free.app/";
  // https://recipeit-dev-582786b38486.herokuapp.com   https://yumaipipeline-3cc427dc62c5.herokuapp.com/ https://bc6a-142-115-90-76.ngrok-free.app
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

// ignore_for_file: unused_local_variable

import 'dart:convert' show json;
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:get/get.dart';
import 'package:hope/screens/persistent_botom_nav.dart';
import 'package:hope/screens/profile_screen.dart';
import 'package:hope/screens/widget_settings_screen.dart';
import 'package:hope/utilities/app.constants.dart'
    show AppConstants, EntitleMents, Utils;
import 'package:jwt_decoder/jwt_decoder.dart' show JwtDecoder;
import 'package:purchases_flutter/models/purchases_configuration.dart'
    show AmazonConfiguration, PurchasesConfiguration;
import 'package:purchases_flutter/purchases_flutter.dart'
    show
        CustomerInfo,
        EntitlementInfo,
        IntroEligibilityStatus,
        LogLevel,
        Purchases,
        PurchasesAreCompletedByRevenueCat,
        Store;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/store.config.dart' show StoreConfig;
import 'config/supabase_config.dart';
import 'screens/auth/controllers/user.auth.controller.dart'
    show SignUpController;
import 'utilities/initial.bindings.dart' show InitialBinding;
import 'core/controllers/translation.controller.dart';
import 'utilities/network.call.dart' show multiPostAPINew;
import 'utilities/splash.screen.dart' show SplashScreen;
import 'screens/chat.bot.page.dart' show routeObserver;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  InitialBinding();
  // Apply bindings manually
  InitialBinding().dependencies();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await _configureSDK();

  // await fetchRevenueCatDetailsFn();

  SharedPreferences sp = await SharedPreferences.getInstance();

  String? authToken = sp.getString('authToken') ?? "";
  AppConstants.authToken = authToken;

  if (AppConstants.authToken.isNotEmpty) {
    bool isTokenExpired = JwtDecoder.isExpired(AppConstants.authToken);

    if (isTokenExpired || AppConstants.authToken.isEmpty) {
      await tokenRefresh();
    }
  }

  String? userId = sp.getString('userId') ?? "";
  AppConstants.userId = userId;

  String? name = sp.getString('name') ?? "";
  AppConstants.name = name;

  String? email = sp.getString('email') ?? "";
  AppConstants.email = email;

  String? isMale = sp.getString('voiceover_gender') ?? 'Male';

  AppConstants.isMale = isMale == 'Male' ? true : false;

  Utils.logger.d('User ID: ${AppConstants.userId}');

  // Initialize controllers
  Get.put(TranslationController());

  runApp(const MainApp());
}

tokenRefresh() async {
  bool isTokenExpired = JwtDecoder.isExpired(AppConstants.authToken);
  Utils.logger.e('Is JWT expired $isTokenExpired');
  if (isTokenExpired) {
    String token = await refreshToken();
    AppConstants.authToken = token;
  }
}

String fetchToken = "api/v1/auth/refresh-token";
Future<String> refreshToken() async {
  String authToken = "";
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await multiPostAPINew(
      param: {"refreshToken": AppConstants.authToken},
      methodName: fetchToken,
      callback: (value) async {
        Map<String, dynamic> valueMap = json.decode(value.response);
        Utils.logger.e('Access token fetched ---> ${valueMap}');
        Utils.logger.e('ValueMap Type ---> ${valueMap.runtimeType}');
        if (valueMap.containsKey('data')) {
          prefs.setString('authToken', valueMap["data"]["accessToken"]);

          AppConstants.authToken = valueMap["data"]["accessToken"];
          authToken = valueMap["data"]["accessToken"];
        } else {
          throw valueMap["message"];
        }
      },
    );
    return authToken;
  } catch (ex) {
    throw ex.toString();
  }
}

Future<void> _configureSDK() async {
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(store: Store.appStore, apiKey: EntitleMents.appleApiKey);
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazon : Store.playStore,
      apiKey: useAmazon ? '' : EntitleMents.appleApiKey,
    );
  }

  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  PurchasesConfiguration configuration;

  if (StoreConfig.isForAmazonAppstore()) {
    configuration =
        AmazonConfiguration(StoreConfig.instance.apiKey)
          ..appUserID = null
          ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  } else {
    configuration = PurchasesConfiguration(
      Platform.isAndroid ? EntitleMents.googleApiKey : EntitleMents.appleApiKey,
    );
  }

  await Purchases.configure(configuration);
}

Future<void> fetchRevenueCatDetailsFn() async {
  final signUpcontroller = Get.find<SignUpController>();
  CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  signUpcontroller.offerings = await Purchases.getOfferings();

  EntitlementInfo? entitlement =
      customerInfo.entitlements.all[EntitleMents.entitlementId];

  Purchases.addCustomerInfoUpdateListener((customerInfo) {
    // Handle subscription status update
    bool isSubscribed =
        customerInfo.entitlements.all[EntitleMents.entitlementId]?.isActive ??
        false;

    if (isSubscribed) {
      AppConstants.isSubscriptionActive = isSubscribed;
    } else {
      AppConstants.isSubscriptionActive = isSubscribed;
    }
  });

  Utils.logger.f('Revenue Cat ID: ${customerInfo.originalAppUserId}');

  AppConstants.currentSubscription = entitlement?.productIdentifier ?? '';

  final trialEligibility =
      await Purchases.checkTrialOrIntroductoryPriceEligibility([
        signUpcontroller
                .offerings
                ?.current
                ?.availablePackages[1]
                .storeProduct
                .identifier
                .toString() ??
            '',
      ]);

  AppConstants.eligibleForTrial =
      trialEligibility.entries.first.value.status ==
              IntroEligibilityStatus.introEligibilityStatusIneligible
          ? false
          : true;
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await fetchRevenueCatDetailsFn();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        390,
        844,
      ), // iPhone 13 dimensions; adjust as needed
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetCupertinoApp(
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          theme: const CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: CupertinoColors.systemBlue,
            scaffoldBackgroundColor: CupertinoColors.black,
          ),
          navigatorObservers: [routeObserver],
          home: const ProfileScreen(),
        );
      },
    );
  }
}

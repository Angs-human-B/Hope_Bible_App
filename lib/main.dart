// ignore_for_file: unused_local_variable

import 'dart:convert' show json;
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, TextStyle;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hope/utilities/app.constants.dart'
    show AppConstants, EntitleMents, Utils;
import 'package:jwt_decoder/jwt_decoder.dart' show JwtDecoder;
import 'package:onesignal_flutter/onesignal_flutter.dart'
    show OSLogLevel, OneSignal;
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    show CupertinoScaffold;
import 'config/store.config.dart' show StoreConfig;
import 'config/supabase_config.dart';
import 'screens/auth/controllers/user.auth.controller.dart'
    show SignUpController;
import 'utilities/initial.bindings.dart' show InitialBinding;
import 'core/controllers/translation.controller.dart';
import 'utilities/network.call.dart' show multiPostAPINew;
import 'services/audio_service.dart';
import 'screens/Pricing&LoginSection/pricing_screen_1.dart' show PricingScreen1;
import 'screens/auth/auth_page.dart' show AuthPage;
import 'screens/onboarding/onboarding_screen_pageview.dart'
    show OnboardingPager;
import 'screens/persistent_botom_nav.dart' show PersistentBottomNav;
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await _initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

Future<void> _initializeApp() async {
  await AudioService.initBackgroundService();

  InitialBinding();
  // Apply bindings manually
  InitialBinding().dependencies();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("e01cb044-c3a0-4917-8f88-a899ecac24f5");
  OneSignal.Notifications.requestPermission(true);

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await _configureSDK();
  WidgetsFlutterBinding.ensureInitialized();
  await fetchRevenueCatDetailsFn();

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

Future<String> _determineInitialScreen() async {
  String route;
  if (AppConstants.userId.isEmpty) {
    route = 'onboarding'; // Id Empty & Subscription inactive
  } else if (!AppConstants.isSubscriptionActive &&
      AppConstants.userId.isNotEmpty) {
    route = 'paywall'; // Id Exists & Subscription inactive
  } else if (AppConstants.isSubscriptionActive && AppConstants.userId.isEmpty) {
    route = 'login'; // Id Empty & Subscription active
  } else {
    route = 'home'; // Both ID & subscription exists
  }

  return route;
}

Widget _buildScreen(String route) {
  final signUpcontroller = Get.find<SignUpController>();
  switch (route) {
    case 'paywall':
      return PricingScreen1(
        isMainScreen: true,
        offering: signUpcontroller.offerings!.current,
      ); // Paywall screen
    case 'onboarding':
      return const OnboardingPager(); // Onboarding screen
    case 'login':
      return const AuthPage(login: true, mainScreenRedirect: true);
    default:
      return const CupertinoScaffold(
        body: PersistentBottomNav(),
      ); // Main tab bar
  }
}

class LogoOnly extends StatelessWidget {
  const LogoOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset('assets/images/logo.svg', width: 80, height: 80),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(390, 844),
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
          home: CupertinoPageScaffold(
            backgroundColor: const Color(0xFF0C111D),
            child: FutureBuilder<String>(
              future: _determineInitialScreen(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CupertinoPageScaffold(
                    child: Center(child: SizedBox()),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'An error occurred. Please try again later.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  final route = snapshot.data ?? 'onboarding';
                  Utils.logger.d("route: $route");

                  return _buildScreen(route);
                  // AnimatedSwitcher(
                  //   duration: const Duration(milliseconds: 500),
                  //   child: _buildScreen(route),
                  // );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

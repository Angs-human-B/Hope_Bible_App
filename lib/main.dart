// ignore_for_file: unused_local_variable

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:hope/utilities/app.constants.dart' show EntitleMents;
import 'package:onesignal_flutter/onesignal_flutter.dart'
    show OSLogLevel, OneSignal;
import 'package:purchases_flutter/models/purchases_configuration.dart'
    show AmazonConfiguration, PurchasesConfiguration;
import 'package:purchases_flutter/purchases_flutter.dart'
    show
        CustomerInfo,
        EntitlementInfo,
        LogLevel,
        Purchases,
        PurchasesAreCompletedByRevenueCat,
        Store;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/store.config.dart' show StoreConfig;
import 'screens/auth/auth_page.dart';
import 'config/supabase_config.dart';
import 'utilities/initial.bindings.dart' show InitialBinding;
import './screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("e01cb044-c3a0-4917-8f88-a899ecac24f5");
  OneSignal.Notifications.requestPermission(true);

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await _configureSDK();

  InitialBinding();
  // Apply bindings manually
  InitialBinding().dependencies();

  // await fetchRevenueCatDetailsFn();

  runApp(const MainApp());
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
    // ..appUserID = null
    // ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  }

  await Purchases.configure(configuration);
}

Future<void> fetchRevenueCatDetailsFn() async {
  // final signUpcontroller = Get.find<SignUpController>();

  CustomerInfo customerInfo = await Purchases.getCustomerInfo();

  print('Customer Info: ${customerInfo}');

  final offerings = await Purchases.getOfferings();

  EntitlementInfo? entitlement =
      customerInfo.entitlements.all[EntitleMents.entitlementId];

  print('Entitlement: ${offerings}');

  // Purchases.addCustomerInfoUpdateListener((customerInfo) {
  //   // Handle subscription status update
  //   bool isSubscribed =
  //       customerInfo.entitlements.all[EntitleMents.entitlementId]?.isActive ??
  //           false;

  //   if (isSubscribed) {
  //     AppConstants.isSubscriptionActive = isSubscribed;
  //     Utils.logger.f(
  //         'Is Subscription Active ------>>>>>>>>>>>>>>>>>>: ${AppConstants.isSubscriptionActive}');
  //   } else {
  //     AppConstants.isSubscriptionActive = isSubscribed;
  //     Utils.logger.f(
  //         'Is Subscription Active ------>>>>>>>>>>>>>>>>>>: ${AppConstants.isSubscriptionActive}');
  //   }
  // });

  // Utils.logger.f('Revenue Cat ID: ${customerInfo.originalAppUserId}');

  // AppConstants.currentSubscription = entitlement?.productIdentifier ?? '';

  // final trialEligibility =
  //     await Purchases.checkTrialOrIntroductoryPriceEligibility([
  //   signUpcontroller
  //           .offerings?.current?.availablePackages[1].storeProduct.identifier
  //           .toString() ??
  //       ''
  // ]);

  // Utils.logger.e(
  //     'Annual Offering --->>${signUpcontroller.offerings?.current?.availablePackages[1]}');

  // AppConstants.eligibleForTrial =
  //     trialEligibility.entries.first.value.status ==
  //             IntroEligibilityStatus.introEligibilityStatusIneligible
  //         ? false
  //         : true;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.systemBlue,
        scaffoldBackgroundColor: CupertinoColors.black,
      ),
      home: SplashScreen(),
    );
  }
}

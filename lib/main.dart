// ignore_for_file: unused_local_variable

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:get/get.dart';
import 'package:hope/utilities/app.constants.dart' show EntitleMents, Utils;
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
import 'config/supabase_config.dart';
import 'utilities/initial.bindings.dart' show InitialBinding;
import './screens/splash_screen.dart';
import 'core/controllers/translation.controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("e01cb044-c3a0-4917-8f88-a899ecac24f5");
  OneSignal.Notifications.requestPermission(true);

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await _configureSDK();
  // await fetchRevenueCatDetailsFn();

  // Initialize controllers
  Get.put(TranslationController());

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
  }

  await Purchases.configure(configuration);
}

Future<void> fetchRevenueCatDetailsFn() async {
  CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  print('Customer Info: ${customerInfo}');

  final offerings = await Purchases.getOfferings();

  EntitlementInfo? entitlement =
      customerInfo.entitlements.all[EntitleMents.entitlementId];

  Utils.logger.d('Entitlement: ${offerings}');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
          home: const SplashScreen(),
        );
      },
    );
  }
}

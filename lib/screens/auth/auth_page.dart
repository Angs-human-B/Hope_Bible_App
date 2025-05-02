// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/cupertino.dart'
    show
        BuildContext,
        Column,
        Container,
        CrossAxisAlignment,
        CupertinoAlertDialog,
        CupertinoButton,
        CupertinoColors,
        CupertinoDialogAction,
        CupertinoPageRoute,
        CupertinoPageScaffold,
        EdgeInsets,
        FontWeight,
        Navigator,
        Padding,
        SafeArea,
        SizedBox,
        Spacer,
        Text,
        TextStyle,
        Widget,
        showCupertinoDialog;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/Constants/icons.dart';
import 'package:hope/screens/persistent_botom_nav.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart' show OneSignal;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import '../../utilities/app.constants.dart' show AppConstants, Utils;
import '../onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
import 'controllers/user.auth.controller.dart' show SignUpController;

class AuthPage extends StatefulWidget {
  final bool login;
  final bool mainScreenRedirect;
  const AuthPage({
    super.key,
    this.login = false,
    this.mainScreenRedirect = false,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = Get.find<SignUpController>();
  final OnboardingController oboardingController =
      Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Color(0xFF31343A)],
                stops: [0.41, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                              builder: (_) => const PersistentBottomNav(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          widget.login
                              ? 'Welcome Back!'
                              : 'Your Subscription \nis Confirmed!',
                          semanticsLabel:
                              widget.login
                                  ? 'Welcome Back!'
                                  : 'Your Subscription is Confirmed!',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color: textWhite,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      widget.login
                          ? const SizedBox()
                          : Text(
                            'Lets create your account.',
                            semanticsLabel: 'Lets create your account.',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: textWhite.withValues(alpha: 0.9),
                              letterSpacing: -0.41,
                            ),
                          ),
                    ],
                  ),
                  SizedBox(height: 48.h),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _handleGoogleSignIn(context),
                    child: Container(
                      height: 54.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardGrey.withValues(alpha: .5), // Google Blue
                        borderRadius: BorderRadius.circular(8.sp),
                        border: Border.all(
                          color: hintTextGrey.withValues(alpha: .3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(googleIcon, height: 22.h),
                          SizedBox(width: 12.w),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: '.SF Pro Text',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _handleAppleSignIn(context),
                    child: Container(
                      height: 54.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardGrey.withValues(alpha: .05), // Google Blue
                        borderRadius: BorderRadius.circular(8.sp),
                        border: Border.all(
                          color: hintTextGrey.withValues(alpha: .3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(appleIcon, height: 26.h),
                          SizedBox(width: 12.w),
                          Text(
                            'Continue with Apple',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: '.SF Pro Text',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: CupertinoColors.white.withValues(alpha: 0.9),
                        letterSpacing: -0.08,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAppleSignIn(BuildContext context) async {
    try {
      final rawNonce = Supabase.instance.client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException(
          'Could not find ID Token from Apple Sign In.',
        );
      }

      final signedInUser = await Supabase.instance.client.auth
          .signInWithIdToken(
            provider: OAuthProvider.apple,
            idToken: idToken,
            nonce: rawNonce,
          );

      if (signedInUser.user != null) {
        final Map<String, dynamic> params = {
          "username": "username",
          "password": "Random1@",
          "name":
              Supabase
                  .instance
                  .client
                  .auth
                  .currentSession
                  ?.user
                  .userMetadata?['name'] ??
              '',
          "email":
              Supabase.instance.client.auth.currentSession?.user.email ?? '',
          "role": "user",
          "providerId": credential.userIdentifier,
          "provider": "Apple",
          "revenueCatId": AppConstants.revenueCatId,
          "currentSubscription": AppConstants.currentSubscription,
          "supabaseId": Supabase.instance.client.auth.currentUser?.id ?? '',
          "one_signal_id": OneSignal.User.pushSubscription.id.toString(),
          // "readingTime": oboardingController.getPageData(page)
          "denomination": oboardingController.getPageData('denomination'),
          "age": oboardingController.getPageData('age'),
          "bibleVersion": oboardingController.getPageData('bibleVersion'),
          "attendChurch": oboardingController.getPageData('attendChurch'),
          "meditate": oboardingController.getPageData('meditate'),
          "studyGroup": oboardingController.getPageData('studyGroup'),
        };
        Utils.logger.f(widget.login);
        Utils.logger.f(params);
        if (widget.login == false) {
          await controller.userRegisterFn(params, context);
          // await Posthog().capture(
          //   properties: {
          //     "name":
          //         Supabase
          //             .instance
          //             .client
          //             .auth
          //             .currentSession
          //             ?.user
          //             .userMetadata?['name']
          //             .toString() ??
          //         '',
          //     "subscriptionType": AppConstants.currentSubscription,
          //     "revenueCatId": AppConstants.revenueCatId,
          //     "one_signal_id": OneSignal.User.pushSubscription.id.toString(),
          //   },
          //   eventName: 'New User - Apple',
          // );
        } else {
          final Map<String, dynamic> loginParams = {
            "email":
                Supabase.instance.client.auth.currentSession?.user.email ?? '',
          };

          await controller.userLoginFn(loginParams, context);
        }
      }
    } catch (error) {
      showCupertinoDialog(
        context: context,
        builder:
            (context) => CupertinoAlertDialog(
              title: const Text('Sign In Failed'),
              content: Text(error.toString()),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      const iosClientId =
          '247752452083-3a1qrv32sd94ekjs7vvapd194pc3vumr.apps.googleusercontent.com';
      const webClientId =
          '247752452083-ibn9m06jgku3jvkm52vrpovcp3eqm77m.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      final signedInUser = await Supabase.instance.client.auth
          .signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );

      if (signedInUser.user != null) {
        // Navigate to ChatBotPage after successful sign in

        String? userId = signedInUser.session?.user.id;
        String? email = signedInUser.user?.email ?? '';
        String? name = signedInUser.user?.userMetadata?['full_name'] ?? '';

        final Map<String, String> params = {
          "username": "username",
          "password": "Random1@",
          "name": name.toString(),
          "email": email,
          "role": "user",
          "providerId": userId.toString(),
          "provider": "Google",
          "revenueCatId": AppConstants.revenueCatId,
          "currentSubscription": AppConstants.currentSubscription,
          "supabaseId": Supabase.instance.client.auth.currentUser?.id ?? '',
          "one_signal_id": OneSignal.User.pushSubscription.id.toString(),
          "denomination": oboardingController.getPageData('denomination'),
          "age": oboardingController.getPageData('age'),
          "bibleVersion": oboardingController.getPageData('bibleVersion'),
          "attendChurch": oboardingController.getPageData('attendChurch'),
          "meditate": oboardingController.getPageData('meditate'),
          "studyGroup": oboardingController.getPageData('studyGroup'),
        };

        Utils.logger.f(params);
        if (widget.login == false) {
          Utils.logger.e(
            'Registering Google User -->> ${signedInUser.user?.userMetadata?['full_name'] ?? ''}',
          );
          await controller.userRegisterFn(params, context);
          // await Posthog().capture(
          //   properties: {
          //     "name":
          //         Supabase
          //             .instance
          //             .client
          //             .auth
          //             .currentSession
          //             ?.user
          //             .userMetadata?['name']
          //             .toString() ??
          //         '',
          //     "subscriptionType": AppConstants.currentSubscription,
          //     "revenueCatId": AppConstants.revenueCatId,
          //     "one_signal_id": OneSignal.User.pushSubscription.id.toString(),
          //   },
          //   eventName: 'New User - Google',
          // );
        } else {
          Utils.logger.e(
            'Logging In Google User -->> ${signedInUser.user?.userMetadata?['full_name'] ?? ''}',
          );
          final Map<String, String> loginParams = {"email": email};
          Utils.logger.f(loginParams);
          await controller.userLoginFn(loginParams, context);
          // await Posthog().capture(
          //   properties: loginParams,
          //   eventName: 'Returning User - Google',
          // );
        }
      }
    } catch (error) {
      showCupertinoDialog(
        context: context,
        builder:
            (context) => CupertinoAlertDialog(
              title: const Text('Sign In Failed'),
              content: Text(error.toString()),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    }
  }
}

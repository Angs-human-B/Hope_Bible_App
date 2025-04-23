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
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import '../bible/controllers/bible.controller.dart' show BibleController;
import '../chat.bot.page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = Get.find<BibleController>();
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // controller.getAllBibleBooksFn();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Welcome to Hope',
                      semanticsLabel: 'Welcome to Hope',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sign in to continue',
                      semanticsLabel: 'Sign in to continue',
                      style: TextStyle(
                        fontSize: 17,
                        color: CupertinoColors.white.withOpacity(0.6),
                        letterSpacing: -0.41,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SignInWithAppleButton(
                    onPressed: () => _handleAppleSignIn(context),
                    style: SignInWithAppleButtonStyle.white,
                    height: 50,
                  ),
                  const SizedBox(height: 16),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _handleGoogleSignIn(context),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4), // Google Blue
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Sign in with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: '.SF Pro Text',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.white.withOpacity(0.4),
                    letterSpacing: -0.08,
                  ),
                ),
              ),
            ],
          ),
        ),
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
        // Navigate to ChatBotPage after successful sign in
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const ChatBotPage()),
        );
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
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const ChatBotPage()),
        );
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

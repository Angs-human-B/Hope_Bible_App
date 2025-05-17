// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/screens/auth/auth_page.dart' show AuthPage;
import 'package:hope/utilities/app.constants.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/OnboardingSection/next_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    show CupertinoScaffold;
import 'package:url_launcher/url_launcher.dart';
import '../../Constants/colors.dart';
import 'controllers/onboarding.controller.dart' show OnboardingController;

class Onboarding1Screen extends StatefulWidget {
  late PageController pageController;
  Onboarding1Screen(this.pageController, {super.key});

  @override
  State<Onboarding1Screen> createState() => _Onboarding1ScreenState();
}

class _Onboarding1ScreenState extends State<Onboarding1Screen> {
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  Future<String> _determineInitialScreen() async {
    // Add your logic here to determine the initial screen
    // For example, check authentication status, user preferences, etc.
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
    return 'auth';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(onboarding1),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 340.w,
              child: Column(
                children: [
                  CommonText("Ready to\n become a better Christian?", 36.sp),
                  SizedBox(height: 34.h),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      onboardingController.currentProgress.value++;

                      Utils.logger.f(
                        onboardingController.currentProgress.value,
                      );

                      widget.pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: NextButton(text: "Get Started", true),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Or",
                    style: TextStyle(fontSize: 12.sp, color: textGrey),
                  ),
                  SizedBox(height: 10.h),
                  // SizedBox(height: 40.h,),
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: textWhite, fontSize: 14.sp),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                await Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).push(
                                  CupertinoPageRoute(
                                    builder:
                                        (context) => CupertinoScaffold(
                                          body: FutureBuilder<String>(
                                            future: _determineInitialScreen(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CupertinoPageScaffold(
                                                  child: Center(
                                                    child: SizedBox(),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const CupertinoPageScaffold(
                                                  child: Center(
                                                    child: Text(
                                                      'An error occurred. Please try again later.',
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return AuthPage(login: true);
                                              }
                                            },
                                          ),
                                        ),
                                  ),
                                );
                              } catch (e) {
                                print('Navigation error: $e');
                                // You can show a snackbar or dialog here to inform the user
                              }
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: textWhite,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: Text.rich(
                      TextSpan(
                        text: "By continuing, you agree to Bilble's ",
                        style: TextStyle(color: textWhite, fontSize: 14.sp),
                        children: [
                          TextSpan(
                            text: "Terms of services",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: textWhite,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () async {
                                    final Uri uri = Uri.parse(
                                      'https://lovable-stack-987930.framer.app/articles/getting-started/copy',
                                    );
                                    if (!await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw Exception(
                                        'Could not launch terms of service',
                                      );
                                    }
                                  },
                          ),
                          TextSpan(text: " & "),
                          TextSpan(
                            text: "Privacy policy.",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: textWhite,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () async {
                                    final Uri uri = Uri.parse(
                                      'https://alive-days-556983.framer.app/articles/getting-started',
                                    );
                                    if (!await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw Exception(
                                        'Could not launch privacy policy',
                                      );
                                    }
                                  },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
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
}

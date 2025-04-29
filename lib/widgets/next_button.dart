// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/screens/onboarding/common_onboarding_screen.dart';

import '../Constants/colors.dart';
import '../screens/onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
import '../screens/onboarding/onboarding11_screen.dart';
import '../screens/onboarding/onboarding13_screen.dart';
import '../screens/onboarding/onboarding17_screen.dart';
import '../screens/onboarding/onboarding18_screen.dart';
import '../screens/onboarding/onboarding2_screen.dart';
import '../screens/onboarding/onboarding3_screen.dart';
import '../screens/onboarding/onboarding5_screen.dart';
import '../screens/onboarding/onboarding6_screen.dart';
import '../screens/onboarding/onboarding7_screen.dart';
import '../screens/onboarding/onboarding9_screen.dart';

class NextButton extends StatefulWidget {
  String text;
  String onTapNextRouteString;
  NextButton(this.text, this.onTapNextRouteString, {super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();
  onNext(String onTapNextRouteString) {
    if (onTapNextRouteString == 'o2') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding2Screen()));
    }
    if (onTapNextRouteString == 'o3') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding3Screen()));
    }
    if (onTapNextRouteString == 'o4') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder:
              (context) =>
                  CommonOnboardingScreen(ageGroup, onboarding4String, 'o5', ''),
        ),
      );
    }
    if (onTapNextRouteString == 'o5') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding5Screen()));
    }
    if (onTapNextRouteString == 'o6') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding6Screen()));
    }
    if (onTapNextRouteString == 'o7') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding7Screen()));
    }
    if (onTapNextRouteString == 'o8') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder:
              (context) => CommonOnboardingScreen(
                readingFrequencies,
                onboarding8String,
                'o9',
                '',
              ),
        ),
      );
    }
    if (onTapNextRouteString == 'o9') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding9Screen()));
    }
    if (onTapNextRouteString == 'o10') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder:
              (context) => CommonOnboardingScreen(
                churchGoingFrequencies,
                onboarding10String,
                'o11',
                '',
              ),
        ),
      );
    }
    if (onTapNextRouteString == 'o11') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding11Screen()));
    }
    if (onTapNextRouteString == 'o12') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder:
              (context) => CommonOnboardingScreen(
                studyGroup,
                onboarding12String,
                'o13',
                '',
              ),
        ),
      );
    }
    if (onTapNextRouteString == 'o13') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding13Screen()));
    }
    if (onTapNextRouteString == 'o14') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder:
              (context) => CommonOnboardingScreen(
                spiritualStages,
                onboarding14String,
                'o15',
                '',
              ),
        ),
      );
    }
    if (onTapNextRouteString == 'o15') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding17Screen()));
    }
    if (onTapNextRouteString == 'o18') {
      onboardingController.currentProgress.value += 1;
      Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => Onboarding18Screen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onNext(widget.onTapNextRouteString);
      },
      child: Container(
        height: 56.h,
        width: 350.h,
        decoration: BoxDecoration(
          color: accentWhite,
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 16.sp,
              color: secondaryBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

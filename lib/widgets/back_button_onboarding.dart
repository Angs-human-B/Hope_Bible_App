import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Constants/colors.dart';
import '../screens/onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;

class BackButtonOnboarding extends StatefulWidget {
  final PageController? pageController;

  const BackButtonOnboarding({this.pageController, super.key});

  @override
  State<BackButtonOnboarding> createState() => _BackButtonOnboardingState();
}

class _BackButtonOnboardingState extends State<BackButtonOnboarding> {
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();
  void onBack() {
    if (onboardingController.currentProgress.value > 0) {
      onboardingController.currentProgress.value -= 1;
    }
    if (widget.pageController != null) {
      widget.pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: secondaryBlack,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}

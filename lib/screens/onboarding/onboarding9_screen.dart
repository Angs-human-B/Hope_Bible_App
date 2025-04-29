import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/image.dart';

import '../../Constants/colors.dart';
import 'controllers/onboarding.controller.dart' show OnboardingController;

class Onboarding9Screen extends StatefulWidget {
  const Onboarding9Screen({super.key});

  @override
  State<Onboarding9Screen> createState() => _Onboarding9ScreenState();
}

class _Onboarding9ScreenState extends State<Onboarding9Screen> {
  final OnboardingController controller = Get.find<OnboardingController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.updatePageData(6, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 117.h),
        Image.asset(onboarding9),
        SizedBox(height: 125.h),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: textWhite,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
            children: [
              TextSpan(text: 'Your '),
              TextSpan(
                text: 'commitment',
                style: TextStyle(
                  color: accentWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    ' aligns with thousands who\'ve found consistent support here.',
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

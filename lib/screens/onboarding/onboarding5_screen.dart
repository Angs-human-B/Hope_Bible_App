import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/image.dart';
import '../../Constants/colors.dart';
import 'controllers/onboarding.controller.dart' show OnboardingController;

class Onboarding5Screen extends StatefulWidget {
  const Onboarding5Screen({super.key});

  @override
  State<Onboarding5Screen> createState() => _Onboarding5ScreenState();
}

class _Onboarding5ScreenState extends State<Onboarding5Screen> {
  final OnboardingController controller = Get.find<OnboardingController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.updatePageData(3, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: textWhite,
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
            children: [
              TextSpan(text: '"'),
              TextSpan(
                text: '80%',
                style: TextStyle(
                  color: accentWhite,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
              TextSpan(text: ' of users aged\nunder '),
              TextSpan(
                text: '18y',
                style: TextStyle(
                  color: accentWhite,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
              TextSpan(text: 'found\nrenewed hope through daily engagement."'),
            ],
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 118.h),
        Image.asset(onboarding5),
        SizedBox(height: 16.h),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 14.sp,
              color: textWhite, // default color for text
            ),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  color: accentWhite,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: '80%',
                style: TextStyle(color: textWhite, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' of users aged under '),
              TextSpan(
                text: '18y',
                style: TextStyle(color: textWhite, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' found renewed\nhope through daily engagement.'),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

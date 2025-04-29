import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/image.dart';
import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import 'controllers/onboarding.controller.dart' show OnboardingController;

class Onboarding7Screen extends StatefulWidget {
  const Onboarding7Screen({super.key});

  @override
  State<Onboarding7Screen> createState() => _Onboarding7ScreenState();
}

class _Onboarding7ScreenState extends State<Onboarding7Screen> {
  final OnboardingController controller = Get.find<OnboardingController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.updatePageData(5, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              TextSpan(text: 'Millions rely on the '),
              TextSpan(
                text: 'NIV\n',
                style: TextStyle(
                  color: accentWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: 'to deepen their spiritual journey daily.'),
            ],
          ),
          textAlign: TextAlign.start,
        ),
        Image.asset(onboarding7),
        SizedBox(height: 48.h),
        Text(
          textAlign: TextAlign.center,
          onboarding7String,
          style: TextStyle(fontSize: 14.sp, color: textWhite),
        ),
      ],
    );
  }
}

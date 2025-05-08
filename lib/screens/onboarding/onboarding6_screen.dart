import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:hope/widgets/ManualTwoColumnGrid2.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/common_text.dart';
import 'controllers/onboarding.controller.dart' show OnboardingController;

class Onboarding6Screen extends StatefulWidget {
  const Onboarding6Screen({super.key});

  @override
  State<Onboarding6Screen> createState() => _Onboarding6ScreenState();
}

class _Onboarding6ScreenState extends State<Onboarding6Screen>
    with AutomaticKeepAliveClientMixin {
  List<String> translations = [
    'ESV',
    'NIV',
    'KJV',
    'NKJV',
    'MSG',
    'NLT',
    "I'm not sure",
  ];

  int selectedIdx = 9;
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onboardingController.isSelected.value = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        CommonText(onboarding6String, 30.sp),
        SizedBox(height: 53.h),
        ManualTwoColumnGrid2(denomination: translations),
      ],
    );
  }
}

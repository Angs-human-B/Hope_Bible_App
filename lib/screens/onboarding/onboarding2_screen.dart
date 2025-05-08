import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/screens/onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
import 'package:hope/widgets/common_text.dart';

import '../../widgets/ManualTwoColumnGrid.dart';

class Onboarding2Screen extends StatefulWidget {
  const Onboarding2Screen({super.key});

  @override
  State<Onboarding2Screen> createState() => _Onboarding2ScreenState();
}

class _Onboarding2ScreenState extends State<Onboarding2Screen>
    with AutomaticKeepAliveClientMixin {
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();
  List<String> denomination = [
    "Baptist",
    "Methodic",
    "Catholic",
    "Presbyterian",
    "Lutheran",
    "Pentecostal",
    "Orthodox",
    "Coptic",
    "Syrian",
    "Greek",
    "Other",
    "Non-denominational",
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // denominationIsSelected = false;
    onboardingController.isSelected.value = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(height: 50),
        SizedBox(height: 84.h),
        CommonText(onboarding2String, 30.sp),
        SizedBox(height: 53.h),
        ManualTwoColumnGrid(denomination: denomination),
      ],
    );
  }
}

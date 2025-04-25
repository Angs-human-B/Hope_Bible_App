import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/back_button.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/common_text_box.dart';
import 'package:hope/widgets/OnboardingSection/next_button.dart';
import 'package:hope/widgets/OnboardingSection/progress_bar.dart';

import '../../widgets/ManualTwoColumnGrid.dart';

class Onboarding2Screen extends StatefulWidget {
  const Onboarding2Screen({super.key});

  @override
  State<Onboarding2Screen> createState() => _Onboarding2ScreenState();
}

class _Onboarding2ScreenState extends State<Onboarding2Screen> {
  List<String> denomination = [
    "Baptist",
    "Methodic",
    "Catholic",
    "Presbyterian",
    "Lutheran",
    "Pentecostal",
    "Orthodox",
    "Other",
    "Non-denominational",
  ];
  int selectedIdx = 9;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50,),
        SizedBox(height:84.h),
        CommonText(onboarding2String, 30.sp),
        SizedBox(height: 53.h),
        ManualTwoColumnGrid(denomination: denomination),
      ],

    );
  }
}



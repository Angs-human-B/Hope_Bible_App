import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/ManualTwoColumnGrid2.dart';

import '../../Constants/global_variable.dart';
import '../../widgets/ManualTwoColumnGrid.dart';
import '../../widgets/back_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/OnboardingSection/next_button.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';

class Onboarding6Screen extends StatefulWidget {
  const Onboarding6Screen({super.key});

  @override
  State<Onboarding6Screen> createState() => _Onboarding6ScreenState();
}

class _Onboarding6ScreenState extends State<Onboarding6Screen> {
   List<String> translations = [
    'ESV',
    'NIV',
    'KJV',
    'NKJV',
    'MSG',
    'NLT',
    'Other',
  ];

  int selectedIdx = 9;
  @override
  Widget build(BuildContext context) {
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



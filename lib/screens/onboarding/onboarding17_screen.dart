import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/common_text_box.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/OnboardingSection/next_button.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';
class Onboarding17Screen extends StatefulWidget {
  const Onboarding17Screen({super.key});

  @override
  State<Onboarding17Screen> createState() => _Onboarding17ScreenState();
}

class _Onboarding17ScreenState extends State<Onboarding17Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        CommonText(onboarding17String, 30.sp, textAlign: TextAlign.start,),
        SizedBox(height: 47.h),
        Padding(
          padding:  EdgeInsets.only(left: 25.w,right: 45.w),
          child: Image.asset(onboarding17),
        ),

      ],
    );
  }
}

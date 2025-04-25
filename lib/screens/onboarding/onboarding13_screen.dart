import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/OnboardingSection/next_button.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';
class Onboarding13Screen extends StatefulWidget {
  const Onboarding13Screen({super.key});

  @override
  State<Onboarding13Screen> createState() => _Onboarding13ScreenState();
}

class _Onboarding13ScreenState extends State<Onboarding13Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        Padding(
          padding:  EdgeInsets.only(left: 10.w),
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: textWhite,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                  height: 1.25

              ),
              children: [
                TextSpan(text: 'Thousands grow spiritually together\nhere—',),
                TextSpan(
                  text: 'you\'re invited',
                  style: TextStyle(
                    color: accentYellow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
        // SizedBox(height: 118.h),
        SizedBox(height: 20.h,),

        Image.asset(
            onboarding13
        ),
        SizedBox(height: 16.h,),
      ],
    );
  }
}

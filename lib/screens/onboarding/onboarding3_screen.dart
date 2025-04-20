import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/progress_bar.dart';


class Onboarding3Screen extends StatefulWidget {
  const Onboarding3Screen({super.key});

  @override
  State<Onboarding3Screen> createState() => _Onboarding3ScreenState();
}

class _Onboarding3ScreenState extends State<Onboarding3Screen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: 120.h,
              child: Row(
                children: [
                  // SizedBox(width: 10.w),
                  BackButtonOnboarding(),
                  SizedBox(width: 30.w),
                  ProgressBar(progress: currentProgress/totalProgress),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: 'Countless ',
                style: TextStyle(
                  color: textWhite,
                  fontSize: 36.sp,
                ),
                children: [
                  TextSpan(
                    text: 'Baptists',
                    style: TextStyle(
                      color: accentYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' have strengthen their faith!',
                  ),
                ],
              ),
              // textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            Image.asset(onboarding3),
            SizedBox(height: 66.h,),
            // SizedBox(height: 30.h,),
            NextButton("Next", "o4"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/progress_bar.dart';


class Onboarding5Screen extends StatefulWidget {
  const Onboarding5Screen({super.key});

  @override
  State<Onboarding5Screen> createState() => _Onboarding5ScreenState();
}

class _Onboarding5ScreenState extends State<Onboarding5Screen> {
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
              TextSpan(
                style: TextStyle(
                  color: textWhite,
                  fontSize: 36.sp,
                ),
                children: [
                  TextSpan(text: '"'),
                  TextSpan(
                    text: '80%',
                    style: TextStyle(
                      color: accentYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' of users aged under '),
                  TextSpan(
                    text: '18y',
                    style: TextStyle(
                      color: accentYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' found renewed hope through daily engagement."'),

                ],
              ),
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 120.h),
            Image.asset(onboarding5),
            SizedBox(height: 128.h,),
            // SizedBox(height: 30.h,),
            NextButton("Next", "o6"),
          ],
        ),
      ),
    );
  }
}

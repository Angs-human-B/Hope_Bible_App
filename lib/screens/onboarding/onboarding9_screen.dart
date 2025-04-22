import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/common_text_box.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/progress_bar.dart';

class Onboarding9Screen extends StatefulWidget {
  const Onboarding9Screen({super.key});

  @override
  State<Onboarding9Screen> createState() => _Onboarding9ScreenState();
}

class _Onboarding9ScreenState extends State<Onboarding9Screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Image.asset(spotLight, fit: BoxFit.cover,width:  MediaQuery.of(context).size.width,)),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 62.h,
                        child: Row(
                          children: [
                            // SizedBox(width: 10.w),
                            BackButtonOnboarding(),
                            SizedBox(width: 26.w),
                            ProgressBar(progress: currentProgress/totalProgress),
                          ],
                        ),
                      ),
                      SizedBox(height: 117.h),
                      Image.asset(
                          onboarding9),
                      SizedBox(height: 125.h),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600
                          ),
                          children: [
                            TextSpan(text: 'Your '),
                            TextSpan(
                              text: 'commitment',
                              style: TextStyle(
                                color: accentYellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' aligns with thousands who\'ve found consistent support here.'),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      )


                    ],
                  ),
                  Positioned(
                      top: 695.h,
                      child: NextButton("Next", "o10")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
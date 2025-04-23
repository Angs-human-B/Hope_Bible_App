import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/progress_bar.dart';

class Onboarding18Screen extends StatefulWidget {
  const Onboarding18Screen({super.key});

  @override
  State<Onboarding18Screen> createState() => _Onboarding18ScreenState();
}

class _Onboarding18ScreenState extends State<Onboarding18Screen> {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: 84.h),
                      CommonText(onboarding18String, 30.sp, textAlign: TextAlign.start,),
                      SizedBox(height: 22.h),
                      CommonText(
                        onboarding18String2, 14.sp, textAlign: TextAlign.start,textColor: textGrey,),
                      SizedBox(height: 40.h),
                      Image.asset(
                          onboarding18
                      ),
                      SizedBox(height: 16.h,),
                      // Text.rich(
                      //   TextSpan(
                      //     style: TextStyle(
                      //       fontSize: 14.sp,
                      //       color: textWhite, // default color for text
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         text: '*',
                      //         style: TextStyle(
                      //           color: accentYellow,
                      //           fontWeight: FontWeight.normal,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: '80%',
                      //         style: TextStyle(
                      //           color: textWhite,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       TextSpan(text: ' of users aged under '),
                      //       TextSpan(
                      //         text: '18y',
                      //         style: TextStyle(
                      //           color: textWhite,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       TextSpan(text: ' found renewed\nhope through daily engagement.'),
                      //     ],
                      //   ),
                      //   textAlign: TextAlign.left,
                      // ),
                    ],
                  ),
                  Positioned(
                      top:690.h,
                      child: NextButton("Next", "o20")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

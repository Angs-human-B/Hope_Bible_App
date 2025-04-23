import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/progress_bar.dart';
class Onboarding13Screen extends StatefulWidget {
  const Onboarding13Screen({super.key});

  @override
  State<Onboarding13Screen> createState() => _Onboarding13ScreenState();
}

class _Onboarding13ScreenState extends State<Onboarding13Screen> {
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
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(text: 'Thousands grow spiritually together\nhere—'),
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
                      // SizedBox(height: 118.h),
                      SizedBox(height: 20.h,),

                      Image.asset(
                          onboarding13
                      ),
                      SizedBox(height: 16.h,),
                    ],
                  ),
                  Positioned(
                      top:690.h,
                      child: NextButton("Next", "o14")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

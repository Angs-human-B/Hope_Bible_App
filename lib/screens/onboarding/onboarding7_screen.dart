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

class Onboarding7Screen extends StatefulWidget {
  const Onboarding7Screen({super.key});

  @override
  State<Onboarding7Screen> createState() => _Onboarding7ScreenState();
}

class _Onboarding7ScreenState extends State<Onboarding7Screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,

                child: Image.asset(spotLight)),
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
                      SizedBox(height: 84.h),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600
                          ),
                          children: [
                            TextSpan(text: 'Millions rely on the '),
                            TextSpan(
                              text: 'NIV\n',
                              style: TextStyle(
                                color: accentYellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: 'to deepen their spiritual journey daily.'),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Image.asset(
                          onboarding7),
                      SizedBox(height: 48.h),
                      Text(
                        textAlign: TextAlign.center,
                        onboarding7String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textWhite
                        ),
                      ),

                    ],
                  ),
                  Positioned(
                      top: 695.h,
                      child: NextButton("Next", "o8")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

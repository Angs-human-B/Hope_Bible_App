import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../Constants/image.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/progress_bar.dart';


class Onboarding11Screen extends StatefulWidget {
  const Onboarding11Screen({super.key});

  @override
  State<Onboarding11Screen> createState() => _Onboarding11ScreenState();
}

class _Onboarding11ScreenState extends State<Onboarding11Screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(onboarding11,),
                  fit: BoxFit.fill
                )
              ),
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
                      SizedBox(height: 477.h),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                              color: textWhite,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600
                          ),
                          children: [
                            TextSpan(text: 'Daily '),
                            TextSpan(
                              text: 'devotionals\n',
                              style: TextStyle(
                                color: accentYellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: 'bring peace—join our\nprayerful community.'),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      )

                    ],
                  ),
                  Positioned(
                      top: 690.h,
                      child: NextButton("Next", "o12")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

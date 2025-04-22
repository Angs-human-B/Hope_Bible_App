import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/back_button.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/common_text_box.dart';
import 'package:hope/widgets/next_button.dart';
import 'package:hope/widgets/progress_bar.dart';

import '../../widgets/ManualTwoColumnGrid.dart';

class Onboarding2Screen extends StatefulWidget {
  const Onboarding2Screen({super.key});

  @override
  State<Onboarding2Screen> createState() => _Onboarding2ScreenState();
}

class _Onboarding2ScreenState extends State<Onboarding2Screen> {
  List<String> denomination = [
    "Baptist",
    "Methodic",
    "Catholic",
    "Presbyterian",
    "Lutheran",
    "Pentecostal",
    "Orthodox",
    "Other",
    "Non-denominational",
  ];
  int selectedIdx = 9;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(

          children: [
            Align(
              alignment: Alignment.topCenter,
                child: Image.asset(spotLight,)),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Stack(
                children: [

                  Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: 62.h,
                        child: Row(
                          children: [
                            BackButtonOnboarding(),
                            SizedBox(width: 26.w),
                            ProgressBar(progress: currentProgress/totalProgress),
                          ],
                        ),
                      ),
                      SizedBox(height:84.h),
                      CommonText(onboarding2String, 30.sp),
                      SizedBox(height: 53.h),
                      ManualTwoColumnGrid(denomination: denomination),

                    ],

                  ),
                  Positioned(
                    top: 695.h,
                      child: NextButton("Next", "o3")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



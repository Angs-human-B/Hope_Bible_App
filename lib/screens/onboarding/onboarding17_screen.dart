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
class Onboarding17Screen extends StatefulWidget {
  const Onboarding17Screen({super.key});

  @override
  State<Onboarding17Screen> createState() => _Onboarding17ScreenState();
}

class _Onboarding17ScreenState extends State<Onboarding17Screen> {
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
                      CommonText(onboarding17String, 30.sp, textAlign: TextAlign.start,),
                      SizedBox(height: 47.h),
                      Padding(
                        padding:  EdgeInsets.only(left: 25.w,right: 45.w),
                        child: Image.asset(onboarding17),
                      ),

                    ],
                  ),
                  Positioned(
                      top: 690.h,
                      child: NextButton("Next", "o18")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

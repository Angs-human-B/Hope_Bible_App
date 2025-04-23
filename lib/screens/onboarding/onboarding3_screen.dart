import 'package:animated_flip_counter/animated_flip_counter.dart';
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


class Onboarding3Screen extends StatefulWidget {
  const Onboarding3Screen({super.key});

  @override
  State<Onboarding3Screen> createState() => _Onboarding3ScreenState();
}

class _Onboarding3ScreenState extends State<Onboarding3Screen> {
  double _count = 9990;
  @override
  void initState() {
    super.initState();
    // After the first frame, update to 10000 so the flip animation runs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _count = 10000);
    });
  }
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
                      SizedBox(height: 84.h),
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: 'Countless ',
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600
                          ),
                          children: [
                            TextSpan(
                              text: 'Baptists\n',
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
                      SizedBox(height: 32.h),
                      Image.asset(onboarding3_1),
                      SizedBox(height: 15.h,),
                      Container(
                        height: 126.h,
                        width: 319.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(onboarding3_2)
                          )
                        ),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText("+", 60.sp,textColor: accentYellow,),
                                AnimatedFlipCounter(
                                  value: _count,
                                  duration: const Duration(seconds: 1),
                                  thousandSeparator: ",",
                                  textStyle: TextStyle(
                                    fontSize: 60.sp,
                                    fontWeight: FontWeight.bold,
                                    color: accentYellow,
                                  ),
                                  // optional: you can format with separators:
                                  // thousandSeparator: ',',
                                ),
                              ],
                            ),),
                      ),
                      SizedBox(height: 22.h,),
                      Image.asset(onboarding3_3),
                    ],
                  ),
                  Positioned(
                      top:690.h,
                      child: NextButton("Next", "o4")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/back_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_box.dart';
import '../../widgets/next_button.dart';
import '../../widgets/progress_bar.dart';


class CommonOnboardingScreen extends StatefulWidget {
  List<String> categoryList;
  String title;
  String nextRoute;

  CommonOnboardingScreen(this.categoryList, this.title, this.nextRoute,{super.key});

  @override
  State<CommonOnboardingScreen> createState() => _CommonOnboardingScreenState();
}

class _CommonOnboardingScreenState extends State<CommonOnboardingScreen> {
  int selectedIdx = 9;

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
                  SizedBox(width: 10.w),
                  BackButtonOnboarding(),
                  SizedBox(width: 35.w),
                  ProgressBar(progress: currentProgress/totalProgress),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            //
            CommonText(widget.title, 36.sp),
            SizedBox(height: 40.h),
            Container(
              height: 480.h,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedIdx = index;
                            });
                          },
                          child: SizedBox(
                              width: 350.w, // width is ignored when inside Expanded/full width
                              height: 52.h,
                              child: CommonTextBox(widget.categoryList[index],
                                  selectedIdx == index ? accentYellow:
                                  textWhite,
                                  selectedIdx == index
                                      ? accentYellow.withOpacity(0.25)
                                      : secondaryGrey,
                                borderColor: selectedIdx == index ? accentYellow : Colors.transparent,
                                clicked:  selectedIdx == index ? true : false,
                              )
                                            ),
                        ),
                        SizedBox(height: 15.h,)
                      ],
                    );}),
            ),
            NextButton("Next", widget.nextRoute)
          ],
        ),
      ),
    );
  }
}

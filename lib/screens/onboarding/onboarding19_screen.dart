import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/OnboardingSection/auto_scroll_caraousel.dart';

class Onboarding19Screen extends StatefulWidget {
  const Onboarding19Screen({super.key});

  @override
  State<Onboarding19Screen> createState() => _Onboarding19ScreenState();
}

class _Onboarding19ScreenState extends State<Onboarding19Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        AutoScrollingImage(
          imageProvider: AssetImage(onboarding19),
          direction: ScrollDirection.leftToRight,
          height: 164,
        ),
        SizedBox(height: 10.h),
        AutoScrollingImage(
          imageProvider: AssetImage(onboarding19),
          direction: ScrollDirection.rightToLeft,
          height: 164,
        ),
        SizedBox(height: 63.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: CommonText(
            onboarding19String,
            18.sp,
            textAlign: TextAlign.start,
            textColor: accentYellow,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: CommonText(
            onboarding19String2,
            14.sp,
            textAlign: TextAlign.start,
            textColor: textGrey,
          ),
        ),
      ],
    );
  }
}

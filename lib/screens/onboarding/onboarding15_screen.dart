import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import '../../Constants/colors.dart';
import '../../widgets/OnboardingSection/auto_scroll_caraousel.dart';

class Onboarding15Screen extends StatefulWidget {
  const Onboarding15Screen({super.key});

  @override
  State<Onboarding15Screen> createState() => _Onboarding15ScreenState();
}

class _Onboarding15ScreenState extends State<Onboarding15Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100.h),

        SizedBox(height: 84.h),
        AutoScrollingImage(
          imageProvider: AssetImage(onboarding15),
          direction: ScrollDirection.leftToRight,
        ),
        SizedBox(height: 5.h),
        AutoScrollingImage(
          imageProvider: AssetImage(onboarding15),
          direction: ScrollDirection.rightToLeft,
        ),
        SizedBox(height: 63.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: textWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: 'Many on a similar path have\n'),
                TextSpan(
                  text: 'transformed',
                  style: TextStyle(
                    color: accentWhite,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                TextSpan(text: ' their spiritual\nlives here.'),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

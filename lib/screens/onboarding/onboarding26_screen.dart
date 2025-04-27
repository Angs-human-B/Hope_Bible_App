import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';
import '../../Constants/colors.dart';

class Onboarding26Screen extends StatefulWidget {
  const Onboarding26Screen({super.key});

  @override
  State<Onboarding26Screen> createState() => _Onboarding26ScreenState();
}

class _Onboarding26ScreenState extends State<Onboarding26Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 43.h),
        CommonText(
          "When You Needed\nLight Most",
          36.sp,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18.h),
        CommonText(
          "Remember the quiet moments you longed for clarity\nand peace? They were never meant to be faced\nalone.",
          13.sp,
          textAlign: TextAlign.center,
          textColor: textGrey,
        ),
      ],
    );
  }
}

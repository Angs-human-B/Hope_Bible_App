import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';

import '../../Constants/colors.dart';

class Onboarding25Screen extends StatefulWidget {
  const Onboarding25Screen({super.key});

  @override
  State<Onboarding25Screen> createState() => _Onboarding25ScreenState();
}

class _Onboarding25ScreenState extends State<Onboarding25Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 465.h),
        CommonText("You’re Not Alone", 36.sp, textAlign: TextAlign.start),
        SizedBox(height: 18.h),
        CommonText(
          "Many have already stepped forward—real growth is happening together. Will you join them?",
          14.sp,
          textAlign: TextAlign.start,
          textColor: textGrey,
        ),
      ],
    );
  }
}

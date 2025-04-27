import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';

class Onboarding18Screen extends StatefulWidget {
  const Onboarding18Screen({super.key});

  @override
  State<Onboarding18Screen> createState() => _Onboarding18ScreenState();
}

class _Onboarding18ScreenState extends State<Onboarding18Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        CommonText(onboarding18String, 30.sp, textAlign: TextAlign.start),
        SizedBox(height: 22.h),
        CommonText(
          onboarding18String2,
          14.sp,
          textAlign: TextAlign.start,
          textColor: textGrey,
        ),
        SizedBox(height: 40.h),
        Image.asset(onboarding18),
        SizedBox(height: 16.h),
      ],
    );
  }
}

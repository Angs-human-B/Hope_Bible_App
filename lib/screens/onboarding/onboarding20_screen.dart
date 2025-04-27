import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';

class Onboarding20Screen extends StatefulWidget {
  const Onboarding20Screen({super.key});

  @override
  State<Onboarding20Screen> createState() => _Onboarding20ScreenState();
}

class _Onboarding20ScreenState extends State<Onboarding20Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        // SizedBox(height: 40.h),
        Image.asset(onboarding20),
        SizedBox(height: 16.h),
        CommonText(onboarding20String, 30.sp, textAlign: TextAlign.center),
        SizedBox(height: 22.h),
        CommonText(
          onboarding20String2,
          14.sp,
          textAlign: TextAlign.center,
          textColor: textGrey,
        ),
      ],
    );
  }
}

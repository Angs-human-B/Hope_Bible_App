import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';
import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';

class Onboarding21Screen extends StatefulWidget {
  const Onboarding21Screen({super.key});

  @override
  State<Onboarding21Screen> createState() => _Onboarding21ScreenState();
}

class _Onboarding21ScreenState extends State<Onboarding21Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 124.h),
        CommonText(onboarding21String, 36.sp, textAlign: TextAlign.center),
        SizedBox(height: 22.h),
        CommonText(
          onboarding21String2,
          14.sp,
          textAlign: TextAlign.center,
          textColor: textGrey,
        ),
        Image.asset(onboarding21),
      ],
    );
  }
}

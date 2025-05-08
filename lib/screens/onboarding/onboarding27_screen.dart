import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/common_text.dart';

class Onboarding27Screen extends StatefulWidget {
  const Onboarding27Screen({super.key});

  @override
  State<Onboarding27Screen> createState() => _Onboarding27ScreenState();
}

class _Onboarding27ScreenState extends State<Onboarding27Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h),
        SizedBox(height: 124.h),
        CommonText(
          'Peace You Can\nCount On?',
          36.sp,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 320.h),
        CommonText('Peace You Can Count On', 20.sp, textAlign: TextAlign.start),
        SizedBox(height: 5.h),
        CommonText(
          'Scripture offers more than inspiration—it\nbrings steady, soul-deep comfort. It’s time to\nmake that part of your every day.',
          14.sp,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }
}

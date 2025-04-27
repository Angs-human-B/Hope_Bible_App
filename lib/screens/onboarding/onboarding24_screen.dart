import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';

class Onboarding24Screen extends StatefulWidget {
  const Onboarding24Screen({super.key});

  @override
  State<Onboarding24Screen> createState() => _Onboarding24ScreenState();
}

class _Onboarding24ScreenState extends State<Onboarding24Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 380.h),
        CommonText(
          "Many have\nrediscovered their\nfaith and fulfillment here.",
          36.sp,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

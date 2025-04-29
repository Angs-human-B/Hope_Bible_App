import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants/colors.dart';

class Onboarding11Screen extends StatefulWidget {
  const Onboarding11Screen({super.key});

  @override
  State<Onboarding11Screen> createState() => _Onboarding11ScreenState();
}

class _Onboarding11ScreenState extends State<Onboarding11Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 477.h),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: textWhite,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
              children: [
                TextSpan(text: 'Daily '),
                TextSpan(
                  text: 'devotionals\n',
                  style: TextStyle(
                    color: accentWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: 'bring peace—join our\nprayerful community.'),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import '../../Constants/colors.dart';

class Onboarding23Screen extends StatefulWidget {
  const Onboarding23Screen({super.key});

  @override
  State<Onboarding23Screen> createState() => _Onboarding23ScreenState();
}

class _Onboarding23ScreenState extends State<Onboarding23Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 380.h),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: textWhite,
              fontSize: 36.sp,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
            children: [
              TextSpan(text: 'Many have\n'),
              TextSpan(
                text: 'rediscovered',
                style: TextStyle(
                  color: accentYellow,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: ' their\nfaith and fulfilment here.'),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

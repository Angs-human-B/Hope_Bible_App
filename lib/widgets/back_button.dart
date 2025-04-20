import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/global_variable.dart';

import '../Constants/colors.dart';

class BackButtonOnboarding extends StatefulWidget {
  const BackButtonOnboarding({super.key});

  @override
  State<BackButtonOnboarding> createState() => _BackButtonOnboardingState();
}

class _BackButtonOnboardingState extends State<BackButtonOnboarding> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        currentProgress -= 1;
        Navigator.pop(context);

      },
      child: Container(
          height: 44.h,
          width: 44.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: secondaryGrey,
          ),
          child: Icon(Icons.arrow_back, color: Colors.white,)),
    );
  }
}

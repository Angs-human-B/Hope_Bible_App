import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/Constants/icons.dart';

import '../Constants/colors.dart';

class BackButtonOnboarding extends StatefulWidget {
  PageController pageController;
  BackButtonOnboarding(this.pageController,{super.key});

  @override
  State<BackButtonOnboarding> createState() => _BackButtonOnboardingState();
}

class _BackButtonOnboardingState extends State<BackButtonOnboarding> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
              height: 44.h,
              width: 44.w,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: CupertinoColors.systemGrey.withOpacity(0.4),
              ),
              child: SvgPicture.asset(arrowLeft, height: 24.h, width: 24.w,)
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/colors.dart';
import '../Constants/global_variable.dart';

class BackButtonOnboarding extends StatelessWidget {
  final PageController? pageController;

  const BackButtonOnboarding({this.pageController, super.key});

  void onBack() {
    if (currentProgress > 0) {
      currentProgress -= 1;
    }
    if (pageController != null) {
      pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: secondaryBlack,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}

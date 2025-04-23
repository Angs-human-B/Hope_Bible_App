import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/colors.dart';

class NextButton extends StatefulWidget {
  final String text;
  final String onTapNextRouteString;
  final PageController? pageController;
  final VoidCallback? onPressed;

  const NextButton(
    this.text,
    this.onTapNextRouteString, {
    this.pageController,
    this.onPressed,
    super.key,
  });

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  void onNext() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
    if (widget.pageController != null) {
      widget.pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNext,
      child: Container(
        height: 56.h,
        width: 350.h,
        decoration: BoxDecoration(
          color: accentYellow,
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 16.sp,
              color: secondaryBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

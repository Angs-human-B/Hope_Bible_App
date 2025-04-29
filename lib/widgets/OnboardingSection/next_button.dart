// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constants/colors.dart';

class NextButton extends StatefulWidget {
  String text;
  bool isOptionSelected;
  NextButton(this.isOptionSelected, {this.text = 'Next', super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      width: 350.h,
      decoration: BoxDecoration(
        color: widget.isOptionSelected ? accentWhite : secondaryGrey,
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
    );
  }
}

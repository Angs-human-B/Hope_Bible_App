// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  String text;
  double fontSize;
  Color textColor;
  FontWeight fontWeight;
  TextAlign textAlign;
  CommonText(
    this.text,
    this.fontSize, {
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: this.fontWeight,
        height: 1.25,
      ),
    );
  }
}

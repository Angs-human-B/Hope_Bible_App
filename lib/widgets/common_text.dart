// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  String text;
  double fontSize;
  Color textColor;
  FontWeight fontWeight;
  CommonText(
    this.text,
    this.fontSize, {
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
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

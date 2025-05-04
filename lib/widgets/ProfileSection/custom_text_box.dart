import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';

class CustomTextFieldBox extends StatelessWidget {
  final String hintText;
  final bool? isEditable;
  final TextEditingController? controller;

  const CustomTextFieldBox({
    super.key,
    required this.hintText,
    this.controller,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      // width: 350.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: secondaryGrey,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(
          color: const Color(0xFFEFEFEF).withValues(alpha: .1),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: CupertinoTextField(
        onChanged: (value) {
          controller?.text = value;
        },
        readOnly: isEditable == false ? true : false,
        controller: controller,
        placeholder: hintText,
        placeholderStyle: TextStyle(color: hintTextGrey),
        style: TextStyle(color: textWhite),
        decoration: null,
        padding: EdgeInsets.zero,
        // backgroundColor: CupertinoColors.transparent,
      ),
    );
  }
}

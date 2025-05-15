import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For some custom colors
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';
import '../../Constants/icons.dart';
import '../../screens/ai_call_screen.dart';
import '../../utilities/app.constants.dart' show AppConstants;

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Input Box
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: secondaryGrey,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: CupertinoColors.systemGrey, width: 0.5),
            ),
            child: Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onSend,
                  child: Icon(
                    CupertinoIcons.plus,
                    color: CupertinoColors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: CupertinoTextField(
                    controller: controller,
                    style: TextStyle(color: hintTextGrey),
                    placeholder: 'Ask Bible AI...',
                    placeholderStyle: TextStyle(
                      color: hintTextGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500
                    ),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(color: secondaryGrey),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AICallScreen(userName: AppConstants.name),
              ),
            );
          },
          child: Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: accentWhite,
              shape: BoxShape.circle,
            ),
            child: Center(child: SvgPicture.asset(callIcon,height: 25.h,width: 25.w)),
          ),
        ),
      ],
    );
  }
}

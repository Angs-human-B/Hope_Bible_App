import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:hope/Constants/colors.dart';
import '../Constants/icons.dart';
import '../utilities/app.constants.dart' show AppConstants;
import '../utilities/text.utility.dart' show AllText;
import '../widgets/ProfileSection/custom_text_box.dart';
import 'auth/controllers/user.auth.controller.dart' show SignUpController;

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text:
          AppConstants.name.isNotEmpty
              ? AppConstants.name
              : AppConstants.email.split('@')[0].split('+')[0],
    );
    emailController = TextEditingController(text: AppConstants.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    arrowLeft,
                    height: 22.h,
                    colorFilter: const ColorFilter.mode(
                      CupertinoColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        middle: AllText(
          text: 'My Account',
          style: TextStyle(
            color: textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CupertinoColors.black,
        border: null,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h),
                      // Center(
                      //   child: Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       CircleAvatar(
                      //         radius: 61.w,
                      //         backgroundImage: AssetImage(
                      //           'assets/images/profile_picture.png',
                      //         ),
                      //       ),
                      //       CupertinoButton(
                      //         padding: EdgeInsets.zero,
                      //         onPressed: () {},
                      //         child: SvgPicture.asset(
                      //           editIcon,
                      //           height: 24.h,
                      //           width: 24.w,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 35.h),
                      AllText(
                        text: "Name",
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextFieldBox(
                        controller: nameController,
                        hintText: "Enter your name",
                      ),
                      SizedBox(height: 25.h),
                      AllText(
                        text: "Email",
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextFieldBox(
                        isEditable: false,
                        controller: emailController,
                        hintText: "Enter your email",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  final controller = Get.find<SignUpController>();
                  final Map<String, dynamic> params = {
                    "value": AppConstants.userId,
                    "data": {"name": nameController.text},
                  };
                  controller.userUpdateFn(params, context, true);
                  HapticFeedback.mediumImpact();
                  setState(() {
                    AppConstants.name = nameController.text;
                  });
                },
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: accentWhite,
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  child: Center(
                    child: AllText(
                      text: "Save Changes",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: secondaryBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

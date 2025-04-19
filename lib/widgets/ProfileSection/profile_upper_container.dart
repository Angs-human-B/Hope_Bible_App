import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/colors.dart';
import '../../Constants/icons.dart';
import 'date_progress_box.dart';

class ProfileUpperContainer extends StatelessWidget {
  const ProfileUpperContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: secondaryGrey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.sp),
          bottomRight: Radius.circular(28.sp),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 34.w,
                    backgroundImage: AssetImage('assets/images/profile_picture.png'),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "johndoe1998@gmail.com",
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Divider(height: 1),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateProgressBox(),
                  SizedBox(width: 16.w),

                  /// Expanded middle section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Goal",
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "15 Minutes",
                              style: TextStyle(
                                color: textWhite,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "/day",
                              style: TextStyle(
                                color: textGrey,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: accentYellow,
                            borderRadius: BorderRadius.circular(99.sp),
                          ),
                          child: Text(
                            "Change My Goal",
                            style: TextStyle(
                              color: secondaryBlack,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Streak icon container
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D0D),
                      borderRadius: BorderRadius.circular(99.sp),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          streaksIcon,
                          height: 18.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "12",
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/Constants/icons.dart';
import 'package:hope/screens/Pricing&LoginSection/pricing_screen_2.dart';

import '../../widgets/PricingSection/pricing_tab_selector.dart';

class PricingScreen1 extends StatefulWidget {
  const PricingScreen1({super.key});

  @override
  State<PricingScreen1> createState() => _PricingScreen1State();
}

class _PricingScreen1State extends State<PricingScreen1> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Color(0xFF31343A),
                ],
                stops: [0.41, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: GestureDetector(
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
                                    closeIcon,
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
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    'Transform your \nSpiritual Journey \nToday',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFF5DE),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 55.h),
                  PricingTabSelector(),
                  SizedBox(height: 18.h),
                  Container(
                    width: 357.w,
                    height: 334.h,
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: cardGrey.withValues(alpha: .4),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _featureRow('assets/images/pricing_option_1.png', 'Your Faith, Your Way', 'Instantly tailor your experience based on your denomination, age, and spiritual journey—get content that actually speaks to you.'),
                        Divider(color: textWhite.withValues(alpha: .08)),
                        _featureRow('assets/images/pricing_option_2.png', ' Peace on Demand', 'Access daily devotionals, guided prayers, and calming reflections anytime you need clarity or calm.'),
                        Divider(color: textWhite.withValues(alpha: .08)),
                        _featureRow('assets/images/pricing_option_3.png', 'Growing Spiritual Community', 'You’re not alone—10,000+ believers like you are already praying, growing, and sharing through the app.'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (_) => const PricingScreen2()),
                      );
                    },
                    child: Container(
                      height: 56.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: accentYellow,
                        borderRadius: BorderRadius.circular(30.sp),
                      ),
                      child: Center(
                        child: Text(
                          "Subscribe for \$49.99/y",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: secondaryBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(String asset, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              asset,
              width: 63.w,
              height: 63.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

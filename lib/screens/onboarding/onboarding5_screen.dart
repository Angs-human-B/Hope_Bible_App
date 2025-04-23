import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import '../../Constants/colors.dart';

class Onboarding5Screen extends StatefulWidget {
  const Onboarding5Screen({super.key});

  @override
  State<Onboarding5Screen> createState() => _Onboarding5ScreenState();
}

class _Onboarding5ScreenState extends State<Onboarding5Screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                spotLight,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 84.h),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(text: '"'),
                            TextSpan(
                              text: '80%',
                              style: TextStyle(
                                color: accentYellow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' of users aged\nunder '),
                            TextSpan(
                              text: '18y',
                              style: TextStyle(
                                color: accentYellow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'found\nrenewed hope through daily engagement."',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 118.h),
                      Image.asset(onboarding5),
                      SizedBox(height: 16.h),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: textWhite, // default color for text
                          ),
                          children: [
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: accentYellow,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: '80%',
                              style: TextStyle(
                                color: textWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' of users aged under '),
                            TextSpan(
                              text: '18y',
                              style: TextStyle(
                                color: textWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' found renewed\nhope through daily engagement.',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

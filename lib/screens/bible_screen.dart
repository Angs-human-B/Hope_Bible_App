import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/Constants/icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/HomeSection/search_bar.dart';
import '../widgets/HomeSection/daily_verse_card.dart';
import '../widgets/HomeSection/feature_section.dart';
import '../widgets/HomeSection/horizontal_card_list.dart';

class BibleScreen extends StatelessWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      // navigationBar: const CupertinoNavigationBar(
      //   middle: Text(''),
      //   backgroundColor: CupertinoColors.black,
      //   border: null,
      // ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            "Select version",
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                'KJV',
                                style: TextStyle(
                                  color: accentYellow,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              SvgPicture.asset(arrowDownIcon, height: 25.h),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 25.h, width: 45.w),
                          SvgPicture.asset(slashIcon, height: 30.h),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            "Select chapter",
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                'Genesis 1',
                                style: TextStyle(
                                  color: accentYellow,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              SvgPicture.asset(arrowDownIcon, height: 25.h),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    'Matthew 11:28–30 (NIV)',
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          'The book of the generation of Jesus Christ, the son of David, the son of Abraham.  Abraham begat Isaac; and Isaac begat Jacob; and Jacob begat Judas and his brethren;  And Judas begat Phares and Zara of Thamar; and Phares begat Esrom; and Esrom begat Aram;  And Aram begat Aminadab; and Aminadab begat Naasson; and Naasson begat Salmon;  And Salmon begat Booz of Rachab; and Booz begat Obed of Ruth; and Obed begat Jesse;  And Jesse begat David the king; and David the king begat Solomon of her that had been the wife of Urias;  And Solomon begat Roboam; and Roboam begat Abia; and Abia begat Asa;  And Asa begat Josaphat; and Josaphat begat Joram; and Joram begat Ozias;  And Ozias begat Joatham; and Joatham begat Achaz; and Achaz begat Ezekias;  And Ezekias begat Manasses; and Manasses begat Amon; and Amon begat Josias;  And Josias begat Jechonias and his brethren, about the time they were carried away to Babylon:  And after they were brought to Babylon, Jechonias begat Salathiel; and Salathiel begat Zorobabel;  And Zorobabel begat Abiud; and Abiud begat Eliakim; and Eliakim begat Azor;  And Azor begat Sadoc; and Sadoc begat Achim; and Achim begat Eliud;  And Eliud begat Eleazar; and Eleazar begat Matthan; and Matthan begat Jacob;  And Jacob begat Joseph the husband of Mary, of whom was born Jesus, who is called Christ.The book of the generation of Jesus Christ, the son of David, the son of Abraham.  Abraham begat Isaac; and Isaac begat Jacob; and Jacob begat Judas and his brethren;  And Judas begat Phares and Zara of Thamar; and Phares begat Esrom; and Esrom begat Aram;  And Aram begat Aminadab; and Aminadab begat Naasson; and Naasson begat Salmon;  And Salmon begat Booz of Rachab; and Booz begat Obed of Ruth; and Obed begat Jesse;  And Jesse begat David the king; and David the king begat Solomon of her that had been the wife of Urias;  And Solomon begat Roboam; and Roboam begat Abia; and Abia begat Asa;  And Asa begat Josaphat; and Josaphat begat Joram; and Joram begat Ozias;  And Ozias begat Joatham; and Joatham begat Achaz; and Achaz begat Ezekias;  And Ezekias begat Manasses; and Manasses begat Amon; and Amon begat Josias;  And Josias begat Jechonias and his brethren, about the time they were carried away to Babylon:  And after they were brought to Babylon, Jechonias begat Salathiel; and Salathiel begat Zorobabel;  And Zorobabel begat Abiud; and Abiud begat Eliakim; and Eliakim begat Azor;  And Azor begat Sadoc; and Sadoc begat Achim; and Achim begat Eliud;  And Eliud begat Eleazar; and Eleazar begat Matthan; and Matthan begat Jacob;  And Jacob begat Joseph the husband of Mary, of whom was born Jesus, who is called Christ.',
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 44.h,
                          width: 44.w,
                          // margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: secondaryGrey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF888888), width: .5),
                          ),
                          child: SvgPicture.asset(
                            arrowLeft,
                            width: 26.w,
                            height: 26.h,
                          ),
                        ),
                        Container(
                          height: 44.h,
                          width: 44.w,
                          // margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: secondaryGrey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF888888), width: .5),
                          ),
                          child: SvgPicture.asset(
                            arrowRight,
                            width: 26.w,
                            height: 26.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  BottomNavBar(bible: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

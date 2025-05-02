import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:get/get.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/utilities/language.utility.dart';

import '../Constants/icons.dart' show arrowLeft;
import '../utilities/text.utility.dart' show AllText;

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
      {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
      {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
      {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
      {'code': 'bn', 'name': 'বাংলা', 'flag': '🇧🇩'},
      {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
      {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
      {'code': 'nl', 'name': 'Nederlands', 'flag': '🇳🇱'},
      {'code': 'sv', 'name': 'Svenska', 'flag': '🇸🇪'},
      {'code': 'pl', 'name': 'Polski', 'flag': '🇵🇱'},
      {'code': 'id', 'name': 'Bahasa Indonesia', 'flag': '🇮🇩'},
      {'code': 'th', 'name': 'ไทย', 'flag': '🇹🇭'},
      {'code': 'he', 'name': 'עברית', 'flag': '🇮🇱'},
      {'code': 'da', 'name': 'Dansk', 'flag': '🇩🇰'},
      {'code': 'fi', 'name': 'Suomi', 'flag': '🇫🇮'},
      {'code': 'no', 'name': 'Norsk', 'flag': '🇳🇴'},
      {'code': 'ro', 'name': 'Română', 'flag': '🇷🇴'},
      {'code': 'hu', 'name': 'Magyar', 'flag': '🇭🇺'},
      {'code': 'cs', 'name': 'Čeština', 'flag': '🇨🇿'},
      {'code': 'el', 'name': 'Ελληνικά', 'flag': '🇬🇷'},
      {'code': 'uk', 'name': 'Українська', 'flag': '🇺🇦'},
      {'code': 'ms', 'name': 'Bahasa Melayu', 'flag': '🇲🇾'},
      {'code': 'sk', 'name': 'Slovenčina', 'flag': '🇸🇰'},
      {'code': 'hr', 'name': 'Hrvatski', 'flag': '🇭🇷'},
      {'code': 'sr', 'name': 'Српски', 'flag': '🇷🇸'},
      {'code': 'bg', 'name': 'Български', 'flag': '🇧🇬'},
      {'code': 'lt', 'name': 'Lietuvių', 'flag': '🇱🇹'},
      {'code': 'lv', 'name': 'Latviešu', 'flag': '🇱🇻'},
      {'code': 'et', 'name': 'Eesti', 'flag': '🇪🇪'},
      {'code': 'sl', 'name': 'Slovenščina', 'flag': '🇸🇮'},
      {'code': 'mt', 'name': 'Malti', 'flag': '🇲🇹'},
      {'code': 'ga', 'name': 'Gaeilge', 'flag': '🇮🇪'},
      {'code': 'is', 'name': 'Íslenska', 'flag': '🇮🇸'},
    ];

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
        backgroundColor: CupertinoColors.black,
        border: null,
        middle: AllText(
          text: 'Select Language',
          style: TextStyle(
            color: textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: GetBuilder<LanguageController>(
          init: LanguageController(),
          builder:
              (controller) => ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected =
                      (lang['code'] == controller.selectedLanguage.value);

                  return GestureDetector(
                    onTap: () {
                      controller.updateLanguage(lang['code']!);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: secondaryGrey,
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            isSelected
                                ? Border.all(color: accentWhite, width: 2)
                                : Border.all(
                                  color: CupertinoColors.systemGrey.withOpacity(
                                    0.3,
                                  ),
                                ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                lang['flag']!,
                                style: TextStyle(fontSize: 24.sp),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                lang['name']!,
                                style: TextStyle(
                                  color: textWhite,
                                  fontSize: 17.sp,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Icon(
                              CupertinoIcons.checkmark_alt_circle_fill,
                              color: accentWhite,
                              size: 24.sp,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}

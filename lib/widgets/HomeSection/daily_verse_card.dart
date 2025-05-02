import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/services/daily_verse_service.dart';
import 'package:flutter/services.dart';
import 'package:hope/services/pexels.service.dart';

import '../../utilities/app.constants.dart' show Utils;
import '../../utilities/text.utility.dart' show AllText;

class DailyVerseCard extends StatefulWidget {
  const DailyVerseCard({super.key});

  @override
  State<DailyVerseCard> createState() => _DailyVerseCardState();
}

class _DailyVerseCardState extends State<DailyVerseCard> {
  String _verseText = '';
  String _verseReference = '';
  bool _isLoading = true;
  String? _imageUrl;
  static const platform = MethodChannel('HopeHomeWidget');

  @override
  void initState() {
    super.initState();
    _loadDailyVerse();
    _loadDailyImage();
  }

  Future<void> _loadDailyVerse() async {
    try {
      setState(() => _isLoading = true);

      // First try to read from app group
      try {
        final Map<dynamic, dynamic> sharedData = await platform.invokeMethod(
          'getSharedData',
        );
        if (sharedData['verse'] != null && sharedData['reference'] != null) {
          setState(() {
            _verseText = sharedData['verse'] as String;
            _verseReference = sharedData['reference'] as String;
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        print('Error reading from app group: $e');
      }

      // If app group read fails, fallback to DailyVerseService
      final verseData = await DailyVerseService.getDailyVerse();
      setState(() {
        _verseText = verseData['verse'] as String;
        _verseReference = verseData['reference'] as String;
        _isLoading = false;
        Utils.logger.i('Verse loaded: $_verseText');
      });
    } catch (e) {
      print('Error loading verse: $e');
      setState(() {
        _verseText =
            'For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.';
        _verseReference = 'John 3:16';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDailyImage() async {
    final imageUrl = await PexelsService.getDailyImage();
    if (mounted && imageUrl != null) {
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  // Future<void> _shareVerse() async {
  //   final textToShare = '"$_verseText"\n- $_verseReference';
  //   await Share.shareWithResult(textToShare);
  // }

  // Future<void> _downloadVerse() async {
  //   try {
  //     // Save to app group to ensure widget gets updated
  //     await platform.invokeMethod('saveToAppGroup', {
  //       'verse': _verseText,
  //       'reference': _verseReference,
  //       'lastUpdate': DateTime.now().toIso8601String(),
  //     });

  //     // ScaffoldMessenger.of(
  //     //   context,
  //     // ).showSnackBar(const SnackBar(content: Text('Verse saved successfully')));
  //   } catch (e) {
  //     // ScaffoldMessenger.of(
  //     //   context,
  //     // ).showSnackBar(const SnackBar(content: Text('Failed to save verse')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.only(
          top: 18.h,
          bottom: 10.h,
          left: 18.w,
          right: 10.w,
        ),
        decoration: BoxDecoration(
          color: secondaryGrey,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 26.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 76.w,
                                  height: 76.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: accentWhite,
                                      width: 1.5.w,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 34.w,
                                  backgroundImage:
                                      _imageUrl != null
                                          ? NetworkImage(_imageUrl!)
                                          : const AssetImage(
                                                'assets/images/the_ark.png',
                                              )
                                              as ImageProvider,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AllText(
                                text: "DAILY VERSE",
                                style: TextStyle(
                                  color: textWhite.withValues(alpha: .66),
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                _verseText,
                                style: TextStyle(
                                  color: textWhite,
                                  fontSize: 20.sp,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _verseReference,
                          style: TextStyle(
                            color: textWhite.withValues(alpha: .66),
                            fontSize: 14.sp,
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     _blackIconBox(
                        //       'assets/icons/download.svg',
                        //       onTap: _downloadVerse,
                        //     ),
                        //     SizedBox(width: 8.w),
                        //     _blackIconBox(
                        //       'assets/icons/share.svg',
                        //       onTap: _shareVerse,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }

  // Widget _blackIconBox(String svgAsset, {VoidCallback? onTap}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: EdgeInsets.all(10.sp),
  //       decoration: BoxDecoration(
  //         color: secondaryBlack,
  //         borderRadius: BorderRadius.circular(8.sp),
  //       ),
  //       child: SvgPicture.asset(
  //         svgAsset,
  //         width: 20.w,
  //         height: 20.h,
  //         colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
  //       ),
  //     ),
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/services/daily_verse_service.dart';
import 'package:flutter/services.dart';
// import 'dart:io' show Platform;
// import 'package:fluttertoast/fluttertoast.dart';

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
  static const platform = MethodChannel('HopeHomeWidget');

  @override
  void initState() {
    super.initState();
    _loadDailyVerse();
    // _loadDailyImage();
  }

  Future<void> _loadDailyVerse() async {
    try {
      setState(() => _isLoading = true);

      // Get verse from DailyVerseService (this will also sync to widget storage)
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

      // Even for fallback verse, sync with widget
      try {
        await platform.invokeMethod('saveToAppGroup', {
          'verse': _verseText,
          'reference': _verseReference,
          'lastUpdate': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        print('Error syncing fallback verse to widget: $e');
      }
    }
  }

  // Future<void> _loadDailyImage() async {
  //   final imageUrl = await PexelsService.getDailyImage();
  //   if (mounted && imageUrl != null) {
  //     setState(() {
  //       _imageUrl = imageUrl;
  //     });
  //   }
  // }

  // Future<void> _addHomeScreenWidget() async {
  //   try {
  //     if (Platform.isIOS) {
  //       await platform.invokeMethod('addHomeScreenWidget', {
  //         'verse': _verseText,
  //         'reference': _verseReference,
  //         'lastUpdate': DateTime.now().toIso8601String(),
  //       });
  //       if (mounted) {
  //         Fluttertoast.showToast(
  //           msg:
  //               'Added to Home Screen. Go to your home screen and tap "Edit" to add the widget.',
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 14.sp,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       Fluttertoast.showToast(
  //         msg: 'Failed to add widget to Home Screen',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 14.sp,
  //       );
  //     }
  //     print('Error adding widget: $e');
  //   }
  // }

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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AllText(
                                    text: "DAILY VERSE",
                                    style: TextStyle(
                                      color: textWhite.withValues(alpha: .66),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  // if (Platform.isIOS)
                                  //   GestureDetector(
                                  //     onTap: _addHomeScreenWidget,
                                  //     child: Container(
                                  //       padding: EdgeInsets.all(8.sp),
                                  //       decoration: BoxDecoration(
                                  //         color: secondaryBlack,
                                  //         borderRadius: BorderRadius.circular(
                                  //           8.sp,
                                  //         ),
                                  //       ),
                                  //       child: Row(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: [
                                  //           Icon(
                                  //             Icons.widgets_outlined,
                                  //             color: Colors.white,
                                  //             size: 16.sp,
                                  //           ),
                                  //           SizedBox(width: 4.w),
                                  //           AllText(
                                  //             text: "Add Widget",
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 12.sp,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
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

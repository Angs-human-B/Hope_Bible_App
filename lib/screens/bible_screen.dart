// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/Constants/icons.dart';
import 'package:hope/screens/bible/controllers/bible.controller.dart'
    show BibleController;

class ChapterPicker extends StatelessWidget {
  final BibleController bibleController;
  final int totalChapters;

  const ChapterPicker({
    super.key,
    required this.bibleController,
    required this.totalChapters,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoPicker(
        backgroundColor: CupertinoColors.black.withOpacity(0.8),
        itemExtent: 40.h,
        scrollController: FixedExtentScrollController(
          initialItem: bibleController.selectedChapterNumber.value - 1,
        ),
        onSelectedItemChanged: (index) {
          bibleController.selectedChapterNumber.value = index + 1;
        },
        children: List.generate(
          totalChapters,
          (index) => Center(
            child: Text(
              'Chapter ${index + 1}',
              style: TextStyle(color: textWhite, fontSize: 17.sp),
            ),
          ),
        ),
      ),
    );
  }
}

class BibleScreen extends StatefulWidget {
  static final RxBool isBottomBarVisible = true.obs;
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  final bibleController = Get.find<BibleController>();
  final selectedVersion = 'NIV'.obs;
  final ScrollController _scrollController = ScrollController();
  final RxBool _isBottomBarVisible = true.obs;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bibleController.getAllBibleVersionsFn(context);
      // Update selectedVersion text with the current version code
      final currentVersion = bibleController.bibleVersions.value
          ?.firstWhereOrNull(
            (v) => v.id == bibleController.selectedVersionId.value,
          );
      if (currentVersion != null) {
        selectedVersion.value = currentVersion.code;
      }
      await bibleController.getAllBibleBooksFn(context);
      await bibleController.getChaptersFn(
        bibleController.selectedBookId.value,
        bibleController.selectedVersionId.value,
        context,
      );
      await bibleController.getVersesByChapterNumberFn(
        bibleController.selectedBookId.value,
        bibleController.selectedVersionId.value,
        bibleController.selectedChapterNumber.value.toString(),
        context,
      );
    });
    super.initState();
  }

  void _showVersionPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: secondaryGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: secondaryGrey.withOpacity(0.9),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: accentYellow, fontSize: 17.sp),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: accentYellow,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (bibleController.isLoadingVersions.value) {
                    return Center(
                      child: CupertinoActivityIndicator(color: accentYellow),
                    );
                  }
                  final versions = bibleController.bibleVersions.value;
                  if (versions == null || versions.isEmpty) {
                    return Center(
                      child: Text(
                        'No versions available',
                        style: TextStyle(color: textWhite, fontSize: 17.sp),
                      ),
                    );
                  }

                  // Find the index of the currently selected version
                  final selectedVersionIndex = versions.indexWhere(
                    (v) => v.id == bibleController.selectedVersionId.value,
                  );

                  return CupertinoPicker(
                    backgroundColor: CupertinoColors.black.withOpacity(0.8),
                    itemExtent: 40.h,
                    scrollController: FixedExtentScrollController(
                      initialItem:
                          selectedVersionIndex != -1 ? selectedVersionIndex : 0,
                    ),
                    onSelectedItemChanged: (index) async {
                      final version = versions[index];
                      selectedVersion.value = version.code;
                      bibleController.selectedVersionId.value = version.id;

                      // Refresh books for the new version
                      await bibleController.getAllBibleBooksFn(context);

                      // If we have a selected book, refresh chapters and verses
                      if (bibleController.selectedBookId.isNotEmpty) {
                        await bibleController.getChaptersFn(
                          bibleController.selectedBookId.value,
                          version.id,
                          context,
                        );

                        // Reset to chapter 1 and fetch its verses
                        bibleController.selectedChapterNumber.value = 1;
                        await bibleController.getVersesByChapterNumberFn(
                          bibleController.selectedBookId.value,
                          version.id,
                          "1",
                          context,
                        );
                      }
                    },
                    children:
                        versions
                            .map(
                              (version) => Center(
                                child: Text(
                                  '${version.code} - ${version.name}',
                                  style: TextStyle(
                                    color: textWhite,
                                    fontSize: 17.sp,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookAndChapterPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: secondaryGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: secondaryGrey.withOpacity(0.9),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: accentYellow, fontSize: 17.sp),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: accentYellow,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (bibleController.isLoadingBooks.value) {
                    return Center(
                      child: CupertinoActivityIndicator(color: accentYellow),
                    );
                  }
                  final books = bibleController.bibleBooks;
                  if (books.isEmpty) {
                    return Center(
                      child: Text(
                        'No books available',
                        style: TextStyle(color: textWhite, fontSize: 17.sp),
                      ),
                    );
                  }

                  // Find the index of the currently selected book
                  final selectedBookIndex = books.indexWhere(
                    (book) => book.id == bibleController.selectedBookId.value,
                  );

                  return Row(
                    children: [
                      // Books picker
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: CupertinoColors.black.withOpacity(
                            0.8,
                          ),
                          itemExtent: 40.h,
                          scrollController: FixedExtentScrollController(
                            initialItem:
                                selectedBookIndex != -1 ? selectedBookIndex : 0,
                          ),
                          onSelectedItemChanged: (index) {
                            final book = books[index];
                            bibleController.selectedBookId.value = book.id;
                            bibleController.selectedChapterNumber.value = 1;
                            // Fetch chapters for the selected book
                            if (bibleController.selectedVersionId.isNotEmpty) {
                              bibleController.getChaptersFn(
                                book.id,
                                bibleController.selectedVersionId.value,
                                context,
                              );
                            }
                          },
                          children:
                              books
                                  .map(
                                    (book) => Center(
                                      child: Text(
                                        book.book,
                                        style: TextStyle(
                                          color: textWhite,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      // Chapters picker
                      Expanded(
                        child: Obx(() {
                          final totalChapters =
                              bibleController.getSelectedBookTotalChapters() ??
                              0;
                          return ChapterPicker(
                            bibleController: bibleController,
                            totalChapters: totalChapters,
                          );
                        }),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
            _scrollController.position.minScrollExtent &&
        _scrollController.position.pixels <
            _scrollController.position.maxScrollExtent) {
      if (_scrollController.position.pixels >
          _scrollController.position.minScrollExtent + 50) {
        _isBottomBarVisible.value = false;
        BibleScreen.isBottomBarVisible.value = false;
      } else {
        _isBottomBarVisible.value = true;
        BibleScreen.isBottomBarVisible.value = true;
      }
    } else {
      _isBottomBarVisible.value = true;
      BibleScreen.isBottomBarVisible.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
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
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _showVersionPicker,
                            child: Row(
                              children: [
                                Obx(
                                  () => Text(
                                    selectedVersion.value,
                                    style: TextStyle(
                                      color: accentYellow,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                SvgPicture.asset(arrowDownIcon, height: 25.h),
                              ],
                            ),
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
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _showBookAndChapterPicker,
                            child: Row(
                              children: [
                                Obx(() {
                                  final bookName =
                                      bibleController.getSelectedBookName() ??
                                      'Select Book';
                                  final chapter =
                                      bibleController
                                          .selectedChapterNumber
                                          .value;
                                  return Text(
                                    '$bookName $chapter',
                                    style: TextStyle(
                                      color: accentYellow,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }),
                                SizedBox(width: 4.w),
                                SvgPicture.asset(arrowDownIcon, height: 25.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Obx(() {
                    return Text(
                      '${bibleController.getSelectedBookName()} ${bibleController.chapters.value?[0].chapter}-${bibleController.chapters.value?.last.chapter} (${selectedVersion.value})',
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        Obx(() {
                          final currentChapter = bibleController.chapters.value
                              ?.firstWhereOrNull(
                                (chapter) =>
                                    chapter.chapter ==
                                    bibleController.selectedChapterNumber.value,
                              );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (currentChapter?.title != null &&
                                  currentChapter!.title.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Text(
                                    currentChapter.title,
                                    style: TextStyle(
                                      color: textWhite,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              RichText(
                                text: TextSpan(
                                  children:
                                      bibleController.verses.map((verse) {
                                        return TextSpan(
                                          children: [
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.top,
                                              child: Transform.translate(
                                                offset: Offset(0, -5),
                                                child: Text(
                                                  '${verse.verse}',
                                                  style: TextStyle(
                                                    color: textWhite,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ${verse.text} ',
                                              style: TextStyle(
                                                color: textWhite,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 60.h,
              left: 0,
              right: 0,
              child: Obx(
                () => AnimatedOpacity(
                  opacity: _isBottomBarVisible.value ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              final currentChapter =
                                  bibleController.selectedChapterNumber.value;
                              final isFirstChapter = currentChapter <= 1;

                              return GestureDetector(
                                onTap:
                                    isFirstChapter
                                        ? null
                                        : () {
                                          bibleController
                                              .selectedChapterNumber
                                              .value = currentChapter - 1;
                                        },
                                child: Container(
                                  height: 44.h,
                                  width: 44.w,
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: secondaryGrey,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF888888),
                                      width: .5,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    arrowLeft,
                                    width: 26.w,
                                    height: 26.h,
                                    colorFilter: ColorFilter.mode(
                                      isFirstChapter
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            Obx(() {
                              final currentChapter =
                                  bibleController.selectedChapterNumber.value;
                              final totalChapters =
                                  bibleController
                                      .getSelectedBookTotalChapters() ??
                                  0;
                              final isLastChapter =
                                  currentChapter >= totalChapters;

                              return GestureDetector(
                                onTap:
                                    isLastChapter
                                        ? null
                                        : () {
                                          bibleController
                                              .selectedChapterNumber
                                              .value = currentChapter + 1;
                                        },
                                child: Container(
                                  height: 44.h,
                                  width: 44.w,
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: secondaryGrey,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF888888),
                                      width: .5,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    arrowRight,
                                    width: 26.w,
                                    height: 26.h,
                                    colorFilter: ColorFilter.mode(
                                      isLastChapter
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      // BottomNavBar(bible: true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

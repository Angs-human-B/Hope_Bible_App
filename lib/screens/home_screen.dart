import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/colors.dart';
import '../Constants/icons.dart';
import '../media/controllers/media.controller.dart';
import '../media/models/media.model.dart';
import '../widgets/HomeSection/feature_card.dart';
import '../widgets/HomeSection/search_bar.dart';
import '../widgets/HomeSection/daily_verse_card.dart';
import '../widgets/HomeSection/feature_section.dart';
import '../widgets/HomeSection/horizontal_card_list.dart';
import '../widgets/HomeSection/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final mediaController = Get.find<MediaController>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final RxList<Media> _searchResults = <Media>[].obs;
  final RxList<Map<String, String>> recentSearches = <Map<String, String>>[].obs;
  final RxBool _hasStartedTyping = false.obs;

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _searchResults.clear();
      return;
    }

    if (!_hasStartedTyping.value) {
      _hasStartedTyping.value = true; // activate overlay
    }

    final lowercaseQuery = query.toLowerCase();
    _searchResults.value = mediaController.mediaList.where((media) {
      return media.title.toLowerCase().contains(lowercaseQuery);
    }).toList();
    _searchResults.refresh();
  }


  @override
  void initState() {
    super.initState();
    // _focusNode.addListener(() {
    //   _hasStartedTyping.value = _focusNode.hasFocus;
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        // 1) Home content
        ListView(
          padding: const EdgeInsets.only(bottom: 10),
          children: [
            SizedBox(height: 60.h),
            CupertinoSearchBar(
              onTap: () {
                FocusScope.of(context).requestFocus(_focusNode);
                _hasStartedTyping.value = true;
              },
            ),
            SizedBox(height: 16.h),
            FeaturedSection(),
            DailyVerseCard(),
            HorizontalCardList(title: 'Recommended'),
            SizedBox(height: 12.h),
            HorizontalCardList(title: 'Watch Now'),
            const SizedBox(height: 100),
          ],
        ),

        // 2) Dim + blur background
        Obx(() {
          if (!_hasStartedTyping.value) return const SizedBox.shrink();
          return Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: secondaryBlack.withOpacity(0.7)),
            ),
          );
        }),

        // 3) Top search bar (now in focus)
        Obx(() {
          if (!_hasStartedTyping.value) return const SizedBox.shrink();
          return Positioned(
            top: 56.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: CupertinoSearchTextField(
                controller: _searchController,
                focusNode: _focusNode,
                placeholder: 'Search for keyword or phrase',
                placeholderStyle: TextStyle(color: textFieldGrey),
                backgroundColor: cardGrey.withValues(alpha: .7),
                padding: EdgeInsets.all(15.sp),
                prefixInsets: EdgeInsets.only(left: 15.w),
                prefixIcon: SvgPicture.asset(searchIcon, height: 16.h),
                suffixInsets: EdgeInsets.only(right: 15.w),
                itemColor: textFieldGrey,
                suffixMode: OverlayVisibilityMode.always,
                onSuffixTap: () {
                      _searchController.clear();
                      _focusNode.unfocus();
                      _hasStartedTyping.value = false;
                      _searchResults.clear();
                    },
                onChanged: (query) {
                  setState(() {
                    _onSearchChanged(query);
                  });
                },

                onSubmitted: (query) {
                  // just hide the keyboard
                  _focusNode.unfocus();
                  if (query.trim().isEmpty) return;

                  if (!recentSearches.any((e) => e['title'] == query.trim())) {
                    recentSearches.insert(0, {
                      'title': query.trim(),
                    });
                  }

                  _onSearchChanged(query.trim());
                },
              ),
            ),
          );
        }),
        Obx(() {
          if (!_hasStartedTyping.value || _searchResults.isEmpty) return const SizedBox.shrink();
          return Positioned(
            top: 56.h + 72.h,
            left: 0,
            right: 0,
            child: SectionHeader(title: "Search Results"),
          );
        }),
        // 4) Results Grid
        Obx(() {
          if (!_hasStartedTyping.value || _searchResults.isEmpty) return const SizedBox.shrink();
          return Positioned(
            top: 56.h + 72.h + 55.h,
            left: 0,
            right: 0,
            height: 240.h,
            child: SizedBox(
              height: 240.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: _searchResults.length,
                itemBuilder:
                    (context, index) => FeatureCard(
                      isSmall: true,
                      media: _searchResults[index],
                      mediaList: _searchResults,
                      index: index,
                    ),
              ),
            ),
          );
        }),

        //5) Recent Searches
        // 5) Recent Searches Section
        Obx(() {
          if (!_hasStartedTyping.value || recentSearches.isEmpty) return const SizedBox.shrink();
          return Positioned(
            top: _searchResults.isEmpty?56.h + 72.h :56.h + 72.h + 55.h + 240.h + 16.h, // below results
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: "Recent Searches"),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardGrey.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: textWhite.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 16.w,right: 16.w, bottom: 8.h,top: 0),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recentSearches.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Container(
                          color: textWhite.withOpacity(0.2),
                          height: 1.h,
                          width: double.infinity,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final item = recentSearches[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              historyClockIcon,
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                CupertinoColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  _searchController.text = item['title']!;
                                  _onSearchChanged(item['title']!);
                                  _focusNode.requestFocus();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: TextStyle(
                                        color: textWhite,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                recentSearches.removeAt(index);
                              },
                              child: SvgPicture.asset(
                                closeIcon,
                                width: 16.w,
                                height: 16.h,
                                colorFilter: const ColorFilter.mode(
                                  CupertinoColors.systemGrey,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

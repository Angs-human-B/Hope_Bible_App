import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../media/controllers/media.controller.dart';
import '../../media/models/media.model.dart';
import 'feature_card.dart';
import 'section_header.dart';

class HorizontalCardList extends StatefulWidget {
  final String title;

  const HorizontalCardList({super.key, required this.title});

  @override
  State<HorizontalCardList> createState() => _HorizontalCardListState();
}

class _HorizontalCardListState extends State<HorizontalCardList> {
  final mediaController = Get.find<MediaController>();
  List<Media> randomizedList = [];
  final _random = Random();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (mediaController.mediaList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await mediaController.getMediaFn({}, context);
        _initializeRandomList();
      });
    } else {
      _initializeRandomList();
    }

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(_onScroll);
  }

  void _initializeRandomList() {
    randomizedList = List<Media>.from(mediaController.mediaList);
    for (var i = randomizedList.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = randomizedList[i];
      randomizedList[i] = randomizedList[j];
      randomizedList[j] = temp;
    }
  }

  void _appendNewItems(List<Media> newItems) {
    randomizedList.addAll(newItems);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // Get the current scroll position and viewport dimensions
    final position = _scrollController.position;
    final viewportWidth = position.viewportDimension;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;

    // Calculate how far we are from the right edge
    final distanceFromRight = maxScroll - currentScroll;

    // If we're within one viewport width from the right edge, load more
    if (distanceFromRight <= viewportWidth) {
      mediaController.loadMoreMedia(context);
    }
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E2127),
      highlightColor: const Color(0xFF2C2F35),
      child: Container(
        width: 152.w,
        height: 234.h,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2127),
          borderRadius: BorderRadius.circular(8.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: widget.title),
        SizedBox(
          height: 240.h,
          child: Obx(() {
            if (mediaController.isLoading.value &&
                mediaController.mediaList.isEmpty) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: 5,
                itemBuilder: (context, index) => _buildShimmerCard(),
              );
            }

            if (mediaController.isError.value) {
              return Center(
                child: Text(
                  mediaController.error.value,
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            if (mediaController.mediaList.isEmpty) {
              return Center(
                child: Text(
                  'No media available',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            // Update our list when new items are loaded
            if (randomizedList.length < mediaController.mediaList.length) {
              final newItems =
                  mediaController.mediaList
                      .skip(randomizedList.length)
                      .toList();
              _appendNewItems(newItems);
            }

            return ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount:
                  randomizedList.length +
                  (mediaController.hasMorePages.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == randomizedList.length) {
                  return _buildShimmerCard();
                }
                return FeatureCard(
                  isSmall: true,
                  media: randomizedList[index],
                  mediaList: randomizedList,
                  index: index,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

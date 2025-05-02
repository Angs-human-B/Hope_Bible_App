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
  late List<Media> randomizedList;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    if (mediaController.mediaList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await mediaController.getMediaFn({}, context);
      });
    }
  }

  List<Media> _getRandomizedList() {
    final list = List<Media>.from(mediaController.mediaList);
    for (var i = list.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
    return list;
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

            final randomList = _getRandomizedList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: randomList.length,
              itemBuilder:
                  (context, index) => FeatureCard(
                    isSmall: true,
                    media: randomList[index],
                    mediaList: randomList,
                    index: index,
                  ),
            );
          }),
        ),
      ],
    );
  }
}

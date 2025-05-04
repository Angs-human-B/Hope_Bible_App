import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../media/controllers/media.controller.dart' show MediaController;
import '../../media/models/media.model.dart' show Media;
import 'package:shimmer/shimmer.dart';

import '../../screens/AudioPlayer/audio_player_screen.dart'
    show AudioPlayerScreen;
import '../../services/favorites_service.dart' show FavoritesController;
import '../../utilities/text.utility.dart' show AllText;

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({super.key});

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  final PageController _pageController = PageController(viewportFraction: 0.55);
  double currentPage = 0;
  final mediaController = Get.find<MediaController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await mediaController.getMediaFn({}, context);
    });
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E2127),
      highlightColor: const Color(0xFF2C2F35),
      child: Container(
        height: 345.h,
        width: 230.w,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2127),
          borderRadius: BorderRadius.circular(8.sp),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SizedBox(
      height: 345.h,
      width: 230.w,
      child: PageView.builder(
        controller: _pageController,
        itemCount: mediaController.mediaList.length,
        itemBuilder: (context, index) {
          final isCurrent = index == currentPage.round();
          final scale = isCurrent ? 1.0 : 0.92;
          final opacity = isCurrent ? 1.0 : 0.7;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: _CupertinoFeatureCard(
                  media: mediaController.mediaList[index],
                  mediaList: mediaController.mediaList,
                  index: index,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerContent() {
    return SizedBox(
      height: 345.h,
      width: 230.w,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 3,
        itemBuilder: (context, index) {
          final isCurrent = index == currentPage.round();
          final scale = isCurrent ? 1.0 : 0.92;
          final opacity = isCurrent ? 1.0 : 0.7;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: opacity,
            child: Transform.scale(scale: scale, child: _buildShimmerCard()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          mediaController.isLoading.value
              ? _buildShimmerContent()
              : _buildContent(),
    );
  }
}

class _CupertinoFeatureCard extends StatelessWidget {
  final Media media;
  final List<Media> mediaList;
  final int index;

  const _CupertinoFeatureCard({
    required this.media,
    required this.mediaList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final favouritesController = Get.find<FavoritesController>();
    return Container(
      height: 345.h,
      width: 230.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
        image: DecorationImage(
          image: NetworkImage(media.thumbnail ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 12,
            child: GestureDetector(
              onTap: () async {
                if (!favouritesController.isFavorite(media.id)) {
                  await favouritesController.toggleFavorite(
                    media.id,
                    mediaData: media,
                  );

                  // favouritesController.favoriteStatus[media.id] = true;

                  // await favouritesController.getFavorites();
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                  child: Container(
                    height: 44.h,
                    width: 130.w,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(68, 68, 68, 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.08),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          final isFavorite = favouritesController.isFavorite(
                            media.id,
                          );
                          return isFavorite
                              ? Icon(
                                CupertinoIcons.check_mark,
                                color: CupertinoColors.white,
                                size: 20.0,
                              )
                              : SvgPicture.asset(
                                'assets/icons/bookmark.svg',
                                width: 12.w,
                                height: 15.h,
                                colorFilter: const ColorFilter.mode(
                                  CupertinoColors.white,
                                  BlendMode.srcIn,
                                ),
                              );
                        }),
                        SizedBox(width: 6.w),
                        Obx(() {
                          final isFavorite = favouritesController.isFavorite(
                            media.id,
                          );
                          return AllText(
                            text: isFavorite ? 'Added to list' : 'Add to list',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 14.sp,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 12,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder:
                        (_) => AudioPlayerScreen(
                          media: media,
                          mediaList: mediaList,
                          currentIndex: index,
                        ),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/icons/play.svg',
                width: 44.w,
                height: 44.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

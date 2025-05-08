import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../media/models/media.model.dart';
import '../../services/favorites_service.dart';
import '../../screens/AudioPlayer/audio_player_screen.dart';

class FeatureCard extends StatelessWidget {
  final bool isSmall;
  final Media media;
  final List<Media> mediaList;
  final int index;

  const FeatureCard({
    super.key,
    this.isSmall = false,
    required this.media,
    required this.mediaList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final double width = isSmall ? 152.w : 200.w;
    final double height = isSmall ? 234.h : 290.h;
    final favouritesController = Get.find<FavoritesController>();

    return GestureDetector(
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
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: NetworkImage(media.thumbnail ?? ''),
          //   fit: BoxFit.cover,
          //   onError: (_, __) => const AssetImage('assets/images/the_ark.png'),
          // ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Optional overlay
            // Container(
            //   decoration: BoxDecoration(
            //     color: CupertinoColors.black.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: CachedNetworkImage(
                imageUrl: media.thumbnail ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                memCacheWidth:
                    (260.w * MediaQuery.of(context).devicePixelRatio).toInt(),
                memCacheHeight:
                    (345.h * MediaQuery.of(context).devicePixelRatio).toInt(),
                placeholder:
                    (context, url) => Center(
                      child: CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: const Color(0xFF1E2127),
                      child: const Icon(
                        CupertinoIcons.photo,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
              ),
            ),

            // Frosted icon box
            Positioned(
              bottom: 8,
              left: 8,
              child: GestureDetector(
                onTap: () async {
                  if (!favouritesController.isFavorite(media.id)) {
                    await favouritesController.toggleFavorite(
                      media.id,
                      mediaData: media,
                    );
                  } else {
                    await favouritesController.toggleFavorite(media.id);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CupertinoColors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Obx(() {
                          final isFavorite = favouritesController.isFavorite(
                            media.id,
                          );
                          return isFavorite
                              ? const Icon(
                                CupertinoIcons.bookmark_fill,
                                color: CupertinoColors.white,
                                size: 18.0,
                              )
                              : const Icon(
                                CupertinoIcons.bookmark,
                                color: CupertinoColors.white,
                                size: 18.0,
                              );
                        }),
                      ),
                    ),
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

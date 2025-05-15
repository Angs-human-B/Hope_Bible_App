import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../favourites/models/favorite.model.dart';
import '../../media/models/media.model.dart' show Media;
import '../../screens/AudioPlayer/audio_player_screen.dart'
    show AudioPlayerScreen;
import '../../utilities/text.utility.dart' show AllText;

class MyListCard extends StatelessWidget {
  final MediaContent media;
  final List<MediaContent> mediaList;

  const MyListCard({super.key, required this.media, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder:
                (_) => AudioPlayerScreen(
                  media: Media(
                    tags: media.tags,
                    createdAt: DateTime.now().toIso8601String(),
                    updatedAt: DateTime.now().toIso8601String(),
                    v: 0,
                    id: media.id,
                    title: media.title,
                    thumbnail: media.thumbnail,
                    signedUrl:
                        "https://pub-e7c8b48e50944a94818381cf31cf90a7.r2.dev/${media.audio}",
                    fileType: media.fileType,
                    audio: media.audio,
                    subtitleInfo: media.subtitleInfo,
                  ),
                  mediaList: List.generate(
                    mediaList.length,
                    (index) => Media(
                      tags: mediaList[index].tags,
                      createdAt: DateTime.now().toIso8601String(),
                      updatedAt: DateTime.now().toIso8601String(),
                      v: 0,
                      id: mediaList[index].id,
                      title: mediaList[index].title,
                      thumbnail: mediaList[index].thumbnail,
                      signedUrl:
                          "https://pub-e7c8b48e50944a94818381cf31cf90a7.r2.dev/${media.audio}",
                      fileType: media.fileType,
                      audio: media.audio,
                      subtitleInfo: media.subtitleInfo,
                    ),
                  ),
                  currentIndex: 0,
                ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 167.w,
            height: 250.h,
            margin: EdgeInsets.only(right: 8.w),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: NetworkImage(
            //       media.thumbnail ?? 'assets/images/the_ark.png',
            //     ),
            //     fit: BoxFit.cover,
            //   ),
            //   borderRadius: BorderRadius.circular(6.sp),
            // ),
            child: ClipRRect(
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
          ),
          SizedBox(height: 8.h),
          AllText(
            text: media.title,
            style: TextStyle(color: CupertinoColors.white, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}

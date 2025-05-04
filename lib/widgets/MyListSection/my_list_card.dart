import 'package:flutter/cupertino.dart';
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
    return Padding(
      padding: EdgeInsets.all(12.sp),
      child: GestureDetector(
        onTap: () {
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
                      signedUrl: media.source,
                      fileType: media.fileType,
                    ),
                    mediaList: List.generate(
                      mediaList.length,
                      (index) => Media(
                        tags: media.tags,
                        createdAt: DateTime.now().toIso8601String(),
                        updatedAt: DateTime.now().toIso8601String(),
                        v: 0,
                        id: media.id,
                        title: media.title,
                        thumbnail: media.thumbnail,
                        signedUrl: media.source,
                        fileType: media.fileType,
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    media.thumbnail ?? 'assets/images/the_ark.png',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(6.sp),
              ),
            ),
            SizedBox(height: 8.h),
            AllText(
              text: media.title,
              style: TextStyle(color: CupertinoColors.white, fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}

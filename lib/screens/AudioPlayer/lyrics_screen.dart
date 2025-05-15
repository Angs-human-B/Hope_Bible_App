// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../Models/lyric_line.dart';
// import '../../services/audio_service.dart';
//
// class LyricsScreen extends StatefulWidget {
//   final AudioService audioService;
//   const LyricsScreen({Key? key, required this.audioService}) : super(key: key);
//
//   @override
//   _LyricsScreenState createState() => _LyricsScreenState();
// }
//
// class _LyricsScreenState extends State<LyricsScreen> {
//   late final AudioService _audio;
//   List<LyricLine> _lines = [];
//   int _currentIndex = 0;
//   late final StreamSubscription<Duration> _posSub;
//
//   @override
//   void initState() {
//     super.initState();
//     _audio = widget.audioService;
//     _loadLyrics();
//     _posSub = _audio.positionStream.listen(_updateLine);
//   }
//
//   Future<void> _loadLyrics() async {
//     _lines = await LyricLine.loadFromAsset('assets/lyrics/sample.lrc');
//     setState(() {});
//   }
//
//   void _updateLine(Duration pos) {
//     final idx = LyricLine.findIndex(_lines, pos);
//     if (idx != _currentIndex) {
//       setState(() => _currentIndex = idx);
//     }
//   }
//
//   @override
//   void dispose() {
//     _posSub.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: const CupertinoNavigationBar(middle: Text('Lyrics')),
//       child: SafeArea(
//         child: ListView.builder(
//           padding: EdgeInsets.all(16.w),
//           itemCount: _lines.length,
//           itemBuilder: (context, index) {
//             final line = _lines[index];
//             final isCurrent = index == _currentIndex;
//             return AnimatedOpacity(
//               opacity: isCurrent ? 1.0 : 0.5,
//               duration: const Duration(milliseconds: 200),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 4.h),
//                 child: Text(
//                   line.text,
//                   style: TextStyle(
//                     color: CupertinoColors.white,
//                     fontSize: isCurrent ? 18.sp : 16.sp,
//                     fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

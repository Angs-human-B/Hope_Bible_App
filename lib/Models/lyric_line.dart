import 'package:flutter/services.dart';

class LyricLine {
  final Duration time;
  final String text;
  LyricLine(this.time, this.text);

  static Future<List<LyricLine>> loadFromAsset(String path) async {
    final data = await rootBundle.loadString(path);
    return data
        .split('\n')
        .map((l) => _parse(l))
        .where((l) => l.text.isNotEmpty)
        .toList();
  }

  static LyricLine _parse(String line) {
    final match = RegExp(r"\[(\d+):(\d+).(\d+)\](.*)").firstMatch(line);
    if (match != null) {
      final m = int.parse(match.group(1)!);
      final s = int.parse(match.group(2)!);
      final ms = int.parse(match.group(3)!) * (match.group(3)!.length == 2 ? 10 : 1);
      return LyricLine(Duration(minutes: m, seconds: s, milliseconds: ms), match.group(4)!);
    }
    return LyricLine(Duration.zero, line);
  }

  static int findIndex(List<LyricLine> lines, Duration pos) {
    for (var i = 0; i < lines.length; i++) {
      if (pos < lines[i].time) return (i - 1).clamp(0, lines.length - 1);
    }
    return lines.length - 1;
  }
}

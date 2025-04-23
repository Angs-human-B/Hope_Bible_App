class StreakResponse {
  final int currentStreak;
  final int longestStreak;
  final DateTime lastUpdatedStreakDate;
  final String message;
  final String? readingTime;

  StreakResponse({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastUpdatedStreakDate,
    required this.message,
    this.readingTime,
  });

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      lastUpdatedStreakDate: DateTime.parse(json['lastUpdatedStreakDate']),
      message: json['message'] ?? '',
      readingTime: json['readingTime'],
    );
  }
}

class StreakHistoryResponse {
  final List<DateTime> streakDates;

  StreakHistoryResponse({required this.streakDates});

  factory StreakHistoryResponse.fromJson(Map<String, dynamic> json) {
    return StreakHistoryResponse(
      streakDates:
          (json['streakDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList(),
    );
  }
}

class ReadingTimeResponse {
  final String readingTime;
  final String message;

  ReadingTimeResponse({required this.readingTime, required this.message});

  factory ReadingTimeResponse.fromJson(Map<String, dynamic> json) {
    return ReadingTimeResponse(
      readingTime: json['readingTime'],
      message: json['message'],
    );
  }
}

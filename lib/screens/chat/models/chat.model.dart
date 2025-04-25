class ChatSessionData {
  final String userId;
  final String title;
  final bool active;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ChatSessionData({
    required this.userId,
    required this.title,
    required this.active,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ChatSessionData.fromJson(Map<String, dynamic> json) {
    return ChatSessionData(
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      active: json['active'] ?? false,
      id: json['_id'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'] ?? 0,
    );
  }
}

class ChatSessionResponse {
  final bool success;
  final ChatSessionData data;

  ChatSessionResponse({required this.success, required this.data});

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponse(
      success: json['success'] ?? false,
      data: ChatSessionData.fromJson(json['data'] ?? {}),
    );
  }
}

class ChatMessageData {
  final String answer;
  final List<String> scriptureReferences;
  final String additionalInsights;
  final String prayerSuggestion;

  ChatMessageData({
    required this.answer,
    required this.scriptureReferences,
    required this.additionalInsights,
    required this.prayerSuggestion,
  });

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    return ChatMessageData(
      answer: json['answer'] ?? '',
      scriptureReferences: List<String>.from(json['scriptureReferences'] ?? []),
      additionalInsights: json['additionalInsights'] ?? '',
      prayerSuggestion: json['prayerSuggestion'] ?? '',
    );
  }
}

class ChatMessageResponse {
  final bool success;
  final ChatMessageData data;

  ChatMessageResponse({required this.success, required this.data});

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      success: json['success'] ?? false,
      data: ChatMessageData.fromJson(json['data'] ?? {}),
    );
  }
}

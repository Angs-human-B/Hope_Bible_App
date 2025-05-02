class SubtitleInfo {
  final String id;
  final String timecode;
  final String subtitle;

  SubtitleInfo({
    required this.id,
    required this.timecode,
    required this.subtitle,
  });

  factory SubtitleInfo.fromJson(Map<String, dynamic> json) {
    return SubtitleInfo(
      id: json['_id'] ?? '',
      timecode: json['timecode'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}

class Media {
  final String id;
  final String title;
  final String? thumbnail;
  final String? video;
  final String? audio;
  final String fileType;
  final int? fileSize;
  final String? mimeType;
  final String? cloudflareKey;
  final String? source;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String? signedUrl;
  final String? youtubeUrl;
  final String? youtubeId;
  final List<SubtitleInfo>? subtitleInfo;

  Media({
    required this.id,
    required this.title,
    this.thumbnail,
    this.video,
    this.audio,
    required this.fileType,
    this.fileSize,
    this.mimeType,
    this.cloudflareKey,
    this.source,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.signedUrl,
    this.youtubeUrl,
    this.youtubeId,
    this.subtitleInfo,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'],
      video: json['video'],
      audio: json['audio'],
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize'],
      mimeType: json['mimeType'],
      cloudflareKey: json['cloudflareKey'],
      source: json['source'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      signedUrl: json['signedUrl'],
      youtubeUrl: json['youtubeUrl'],
      youtubeId: json['youtubeId'],
      subtitleInfo:
          (json['subtitleInfo'] as List?)
              ?.map((item) => SubtitleInfo.fromJson(item))
              .toList(),
    );
  }
}

class MediaResponse {
  final List<Media> media;
  final int total;
  final int page;
  final int totalPages;

  MediaResponse({
    required this.media,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory MediaResponse.fromJson(Map<String, dynamic> json) {
    return MediaResponse(
      media:
          (json['media'] as List?)
              ?.map((item) => Media.fromJson(item))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

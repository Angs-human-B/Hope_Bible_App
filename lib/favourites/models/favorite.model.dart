import '../../media/models/media.model.dart' show SubtitleInfo;

class FavoriteMedia {
  final String id;
  final String userId;
  final MediaContent media;
  final String createdAt;
  final String updatedAt;
  final int v;

  FavoriteMedia({
    required this.id,
    required this.userId,
    required this.media,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory FavoriteMedia.fromJson(Map<String, dynamic> json) {
    return FavoriteMedia(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      media: MediaContent.fromJson(json['media'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}

class MediaContent {
  final String id;
  final String title;
  final String? thumbnail;
  final String fileType;
  final String? source;
  final List<String> tags;
  final bool featured;
  final String? url;
  final String? audio;
  final List<SubtitleInfo>? subtitleInfo;

  MediaContent({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.fileType,
    this.source,
    required this.tags,
    required this.featured,
    this.url,
    this.audio,
    this.subtitleInfo,
  });

  factory MediaContent.fromJson(Map<String, dynamic> json) {
    return MediaContent(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'],
      fileType: json['fileType'] ?? '',
      source: json['source'],
      tags: List<String>.from(json['tags'] ?? []),
      featured: json['featured'] ?? false,
      url: json['url'],
      audio: json['audio'],
      subtitleInfo:
          (json['subtitleInfo'] as List?)
              ?.map((item) => SubtitleInfo.fromJson(item))
              .toList(),
    );
  }
}

class FavoritesResponse {
  final List<FavoriteMedia> favorites;
  final Pagination pagination;

  FavoritesResponse({required this.favorites, required this.pagination});

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) {
    return FavoritesResponse(
      favorites:
          (json['favorites'] as List?)
              ?.map((item) => FavoriteMedia.fromJson(item))
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

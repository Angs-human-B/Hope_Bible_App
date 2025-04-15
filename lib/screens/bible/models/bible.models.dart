class BibleTranslation {
  final String id;
  final String code;
  final String name;
  final String language;
  final int numericId;
  final int year;
  final String publisher;
  final String copyright;
  final bool isActive;

  BibleTranslation({
    required this.id,
    required this.code,
    required this.name,
    required this.language,
    required this.numericId,
    required this.year,
    required this.publisher,
    required this.copyright,
    required this.isActive,
  });

  factory BibleTranslation.fromJson(Map<String, dynamic> json) {
    return BibleTranslation(
      id: json['_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      numericId: json['id'] as int,
      year: json['year'] as int,
      publisher: json['publisher'] as String,
      copyright: json['copyright'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'name': name,
      'language': language,
      'id': numericId,
      'year': year,
      'publisher': publisher,
      'copyright': copyright,
      'isActive': isActive,
    };
  }
}

class BibleTranslationResponse {
  final bool success;
  final List<BibleTranslation> data;

  BibleTranslationResponse({required this.success, required this.data});

  factory BibleTranslationResponse.fromJson(Map<String, dynamic> json) {
    return BibleTranslationResponse(
      success: json['success'] as bool,
      data:
          (json['data'] as List)
              .map((e) => BibleTranslation.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.map((e) => e.toJson()).toList()};
  }
}

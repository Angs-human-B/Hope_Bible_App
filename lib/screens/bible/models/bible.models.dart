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

class BibleBook {
  final String id;
  final String book;
  final int chapters;
  final String testament;
  final int orderNumber;

  BibleBook({
    required this.id,
    required this.book,
    required this.chapters,
    required this.testament,
    required this.orderNumber,
  });

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      id: json['_id'] as String,
      book: json['book'] as String,
      chapters: json['chapters'] as int,
      testament: json['testament'] as String,
      orderNumber: json['orderNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'book': book,
      'chapters': chapters,
      'testament': testament,
      'orderNumber': orderNumber,
    };
  }
}

class BibleBookResponse {
  final bool success;
  final List<BibleBook> data;

  BibleBookResponse({required this.success, required this.data});

  factory BibleBookResponse.fromJson(Map<String, dynamic> json) {
    return BibleBookResponse(
      success: json['success'] as bool,
      data:
          (json['data'] as List)
              .map((e) => BibleBook.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class BibleChapter {
  final String id;
  final int chapter;
  final String title;
  final int verseCount;

  BibleChapter({
    required this.id,
    required this.chapter,
    required this.title,
    required this.verseCount,
  });

  factory BibleChapter.fromJson(Map<String, dynamic> json) {
    return BibleChapter(
      id: json['_id']?.toString() ?? '',
      chapter: json['chapter'] as int? ?? 1,
      title: json['title']?.toString() ?? '',
      verseCount: json['verseCount'] as int? ?? 0,
    );
  }
}

class BibleChapterResponse {
  final bool success;
  final List<BibleChapter> data;

  BibleChapterResponse({required this.success, required this.data});

  factory BibleChapterResponse.fromJson(Map<String, dynamic> json) {
    return BibleChapterResponse(
      success: json['success'] as bool? ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => BibleChapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BibleVerse {
  final String id;
  final int verse;
  final bool isFootnote;
  final String text;

  BibleVerse({
    required this.id,
    required this.verse,
    required this.isFootnote,
    required this.text,
  });

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      id: json['_id'] as String,
      verse: json['verse'] as int,
      isFootnote: json['isFootnote'] as bool,
      text: json['text'] as String,
    );
  }
}

class BibleVerseResponse {
  final bool success;
  final List<BibleVerse> data;

  BibleVerseResponse({required this.success, required this.data});

  factory BibleVerseResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final versesList = data['verses'] as List;
    return BibleVerseResponse(
      success: json['success'] as bool,
      data:
          versesList
              .map((e) => BibleVerse.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

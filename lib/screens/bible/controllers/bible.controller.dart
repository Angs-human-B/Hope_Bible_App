// ignore_for_file: unused_element

import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utilities/app.constants.dart' show AppConstants, Utils;
import '../../../utilities/mixins.dart' show RefreshToken;
import 'package:get/get.dart';
import '../../../utilities/network.call.dart' show getAPI;
import '../models/bible.models.dart'
    show
        BibleTranslationResponse,
        BibleBookResponse,
        BibleBook,
        BibleTranslation,
        BibleChapterResponse,
        BibleChapter,
        BibleVerse,
        BibleVerseResponse;

class BibleController extends GetxController with RefreshToken {
  RxBool isLoadingVersions = false.obs;
  RxBool isLoadingBooks = false.obs;
  RxBool isLoadingChapters = false.obs;
  RxBool isLoadingVerses = false.obs;
  RxBool isError = false.obs;
  RxString error = "".obs;
  RxList<BibleBook> bibleBooks = <BibleBook>[].obs;
  Rx<List<BibleTranslation>?> bibleVersions = Rx<List<BibleTranslation>?>(null);
  Rx<List<BibleChapter>?> chapters = Rx<List<BibleChapter>?>(null);
  RxString currentVerses = ''.obs;
  RxList<BibleVerse> verses = <BibleVerse>[].obs;

  // Selected states
  final selectedBookId = ''.obs;
  final selectedVersionId = ''.obs;
  final selectedChapterNumber = 1.obs;

  // SharedPreferences keys
  static const String _lastVersionIdKey = 'last_bible_version_id';
  static const String _lastVersionCodeKey = 'last_bible_version_code';
  static const String _lastBookIdKey = 'last_bible_book_id';
  static const String _lastChapterNumberKey = 'last_bible_chapter_number';

  Worker? _chapterWorker;
  Worker? _versionWorker;
  Worker? _bookWorker;

  @override
  void onInit() {
    super.onInit();

    // Setup version change worker
    _versionWorker = ever(selectedVersionId, (String versionId) {
      if (versionId.isNotEmpty) {
        saveLastSession();
      }
    });

    // Setup book change worker
    _bookWorker = ever(selectedBookId, (String bookId) {
      if (bookId.isNotEmpty) {
        saveLastSession();
      }
    });

    // Setup chapter change worker
    _chapterWorker = ever(selectedChapterNumber, (int chapterNumber) async {
      if (selectedBookId.isNotEmpty &&
          selectedVersionId.isNotEmpty &&
          !isLoadingVerses.value) {
        // Save session first to ensure we don't lose the chapter change
        await saveLastSession();

        // Then fetch verses for the new chapter
        await getVersesByChapterNumberFn(
          selectedBookId.value,
          selectedVersionId.value,
          chapterNumber.toString(),
          Get.context,
        );
      }
    });

    initializeData();
  }

  @override
  void onClose() {
    _chapterWorker?.dispose();
    _versionWorker?.dispose();
    _bookWorker?.dispose();
    super.onClose();
  }

  Future<void> initializeData() async {
    try {
      // First load saved session
      await loadLastSession();

      // Get all versions and books (this sets defaults if no saved data)
      await getAllBibleVersionsFn(Get.context);
      await getAllBibleBooksFn(Get.context);

      // If we have stored IDs, use them to load the correct content
      if (selectedVersionId.isNotEmpty && selectedBookId.isNotEmpty) {
        // Get chapters for the stored book and version
        await getChaptersFn(
          selectedBookId.value,
          selectedVersionId.value,
          Get.context,
        );

        // Get verses for the stored chapter
        if (selectedChapterNumber.value > 0) {
          await getVersesByChapterNumberFn(
            selectedBookId.value,
            selectedVersionId.value,
            selectedChapterNumber.value.toString(),
            Get.context,
          );
        }
      }

      Utils.logger.f(
        'Initialization complete with: Version=${selectedVersionId.value}, Book=${selectedBookId.value}, Chapter=${selectedChapterNumber.value}',
      );
    } catch (e) {
      Utils.logger.e('Error initializing data: $e');
    }
  }

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  String getAllBibleVersions = "api/v1/bible/versions";
  String getAllChapters = "api/v1/bible/chapters";
  String getVersesByChapter = "api/v1/bible/verses/chapter";
  String getVersesByChapterNumber = "api/v1/bible";

  Future getAllBibleVersionsFn(context) async {
    try {
      isLoadingVersions(true);
      isError(false);
      error("");
      await getAPI(
        methodName: getAllBibleVersions,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = BibleTranslationResponse.fromJson(valueMap);

            // Sort versions alphabetically by code
            final sortedVersions =
                response.data.toList()
                  ..sort((a, b) => a.code.compareTo(b.code));

            bibleVersions.value = sortedVersions;

            // Only set NIV as default if no version is selected
            if (selectedVersionId.isEmpty) {
              final nivVersion = sortedVersions.firstWhereOrNull(
                (v) => v.code == 'NIV',
              );
              if (nivVersion != null) {
                selectedVersionId.value = nivVersion.id;
              }
            }
          } else {
            isError(true);
            error(valueMap["message"]);
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
    } finally {
      isLoadingVersions(false);
    }
  }

  String getAllBibleBooks = "api/v1/bible/books";
  Future getAllBibleBooksFn(context) async {
    try {
      isLoadingBooks(true);
      isError(false);
      error("");
      await getAPI(
        methodName: getAllBibleBooks,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = BibleBookResponse.fromJson(valueMap);
            bibleBooks.value = response.data;

            // Only set Genesis as default if no book is selected
            if (selectedBookId.isEmpty) {
              final genesis = response.data.firstWhereOrNull(
                (b) => b.book == 'Genesis',
              );
              if (genesis != null) {
                selectedBookId.value = genesis.id;
                selectedChapterNumber.value = 1;
              }
            }
          } else {
            isError(true);
            error(valueMap["message"]);
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
    } finally {
      isLoadingBooks(false);
    }
  }

  Future getChaptersFn(String bookId, String versionId, context) async {
    try {
      isLoadingChapters(true);
      isError(false);
      error("");
      await getAPI(
        methodName: "$getAllChapters/$bookId/$versionId",
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = BibleChapterResponse.fromJson(valueMap);
            chapters.value = response.data;

            // Only update IDs if they're different to prevent unnecessary refreshes
            if (selectedBookId.value != bookId) {
              selectedBookId.value = bookId;
            }
            if (selectedVersionId.value != versionId) {
              selectedVersionId.value = versionId;
            }

            await saveLastSession();
          } else {
            isError(true);
            error(valueMap["message"]);
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
    } finally {
      isLoadingChapters(false);
    }
  }

  Future getVersesByChapterIdFn(String chapterId, context) async {
    try {
      isLoadingVerses(true);
      isError(false);
      error("");
      await getAPI(
        methodName: "$getVersesByChapter/$chapterId",
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = BibleVerseResponse.fromJson(valueMap);
            Utils.logger.f("Verses fetched: ${response.data.length}");
            verses.value = response.data;

            // Format verses for display
            final formattedVerses = response.data
                .map((verse) {
                  return "${verse.verse}. ${verse.text}";
                })
                .join("\n\n");

            currentVerses.value = formattedVerses;
            Utils.logger.f(
              "Verses fetched successfully ${currentVerses.value}",
            );
            // Handle the verses response here
            Utils.logger.f("Verses fetched successfully");
          } else {
            isError(true);
            error(valueMap["message"]);
            isLoadingVerses(false);
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
      isLoadingVerses(false);
    } finally {
      isLoadingVerses(false);
    }
  }

  Future getVersesByChapterNumberFn(
    String bookId,
    String versionId,
    String chapterNumber,
    context,
  ) async {
    try {
      isLoadingVerses(true);
      isError(false);
      error("");
      await getAPI(
        methodName:
            "$getVersesByChapterNumber/$bookId/$versionId/chapter/$chapterNumber",
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = BibleVerseResponse.fromJson(valueMap);
            verses.value = response.data;

            // Format verses for display
            final formattedVerses = response.data
                .map((verse) {
                  return "${verse.verse}. ${verse.text}";
                })
                .join("\n\n");

            currentVerses.value = formattedVerses;
          } else {
            isError(true);
            error(valueMap["message"]);
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
    } finally {
      isLoadingVerses(false);
    }
  }

  // Helper method to get selected book name
  String? getSelectedBookName() {
    if (selectedBookId.isEmpty) return null;
    return bibleBooks
        .firstWhereOrNull((book) => book.id == selectedBookId.value)
        ?.book;
  }

  // Helper method to get total chapters for selected book
  int? getSelectedBookTotalChapters() {
    if (selectedBookId.isEmpty) return null;
    return bibleBooks
        .firstWhereOrNull((book) => book.id == selectedBookId.value)
        ?.chapters;
  }

  Future<void> saveLastSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save version data
      await prefs.setString(_lastVersionIdKey, selectedVersionId.value);
      final currentVersion = bibleVersions.value?.firstWhereOrNull(
        (v) => v.id == selectedVersionId.value,
      );
      if (currentVersion != null) {
        await prefs.setString(_lastVersionCodeKey, currentVersion.code);
      }

      // Save book and chapter data
      await prefs.setString(_lastBookIdKey, selectedBookId.value);
      await prefs.setInt(_lastChapterNumberKey, selectedChapterNumber.value);

      Utils.logger.f(
        'Session saved successfully: Version=${selectedVersionId.value}, Book=${selectedBookId.value}, Chapter=${selectedChapterNumber.value}',
      );
    } catch (e) {
      Utils.logger.e('Error saving session: $e');
    }
  }

  Future<void> loadLastSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final lastVersionId = prefs.getString(_lastVersionIdKey);
      final lastBookId = prefs.getString(_lastBookIdKey);
      final lastChapterNumber = prefs.getInt(_lastChapterNumberKey);

      if (lastVersionId != null) {
        selectedVersionId.value = lastVersionId;
      }

      if (lastBookId != null) {
        selectedBookId.value = lastBookId;
      }

      if (lastChapterNumber != null) {
        selectedChapterNumber.value = lastChapterNumber;
      }

      Utils.logger.f('Session loaded successfully');
    } catch (e) {
      Utils.logger.e('Error loading session: $e');
    }
  }
}

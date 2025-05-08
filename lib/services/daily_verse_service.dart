import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class DailyVerseService {
  static const String _lastUpdateKey = 'last_verse_update';
  static const String _verseTextKey = 'daily_verse_text';
  static const String _verseReferenceKey = 'daily_verse_reference';
  static const MethodChannel platform = MethodChannel('HopeHomeWidget');

  static Future<Map<String, dynamic>> getDailyVerse() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(_lastUpdateKey);
    final now = DateTime.now();

    // Check if we need to fetch new verse (daily)
    if (lastUpdate == null ||
        DateTime.parse(lastUpdate).day != now.day ||
        DateTime.parse(lastUpdate).month != now.month ||
        DateTime.parse(lastUpdate).year != now.year) {
      // Fetch new verse
      return _fetchAndSaveNewVerse();
    }

    // Return cached verse if available
    final verseText = prefs.getString(_verseTextKey);
    final verseReference = prefs.getString(_verseReferenceKey);

    if (verseText != null && verseReference != null) {
      // Always sync with widget storage
      await _saveToUserDefaults(verseText, verseReference);
      return {'verse': verseText, 'reference': verseReference};
    }

    // Fallback to fetching new verse if cache is incomplete
    return _fetchAndSaveNewVerse();
  }

  static Future<Map<String, dynamic>> _fetchAndSaveNewVerse() async {
    try {
      // Fetch verse from the API
      final verseResponse = await http.get(
        Uri.parse('https://labs.bible.org/api/?passage=random&type=json'),
      );

      if (verseResponse.statusCode != 200) {
        throw Exception('Failed to load verse');
      }

      final List<dynamic> verseDataList = json.decode(verseResponse.body);
      if (verseDataList.isEmpty) {
        throw Exception('No verse data received');
      }

      final verseData = verseDataList[0];
      final verseText = verseData['text'] as String;
      final reference =
          '${verseData['bookname']} ${verseData['chapter']}:${verseData['verse']}';

      final now = DateTime.now().toIso8601String();

      // First save to widget storage to ensure it's always up to date
      await _saveToUserDefaults(verseText, reference);

      // Then save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdateKey, now);
      await prefs.setString(_verseTextKey, verseText);
      await prefs.setString(_verseReferenceKey, reference);

      return {'verse': verseText, 'reference': reference};
    } catch (e) {
      print('Error fetching daily verse: $e');

      // Default verse
      const defaultVerse =
          'For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.';
      const defaultReference = 'John 3:16';

      // Save default verse to both storages
      await _saveToUserDefaults(defaultVerse, defaultReference);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      await prefs.setString(_verseTextKey, defaultVerse);
      await prefs.setString(_verseReferenceKey, defaultReference);

      return {'verse': defaultVerse, 'reference': defaultReference};
    }
  }

  static Future<void> _saveToUserDefaults(
    String verse,
    String reference,
  ) async {
    try {
      await platform.invokeMethod('saveToAppGroup', {
        'verse': verse,
        'reference': reference,
        'lastUpdate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving to UserDefaults: $e');
    }
  }
}

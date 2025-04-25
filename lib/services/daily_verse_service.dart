import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class DailyVerseService {
  static const String _lastUpdateKey = 'last_verse_update';
  static const String _verseTextKey = 'daily_verse_text';
  static const String _verseReferenceKey = 'daily_verse_reference';
  static const String _backgroundImageUrlKey = 'daily_background_image_url';
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
      // Fetch new verse and image
      return _fetchAndSaveNewVerse();
    }

    // Return cached verse if available
    final verseText = prefs.getString(_verseTextKey);
    final verseReference = prefs.getString(_verseReferenceKey);
    final imageUrl = prefs.getString(_backgroundImageUrlKey);

    if (verseText != null && verseReference != null) {
      return {
        'verse': verseText,
        'reference': verseReference,
        'imageUrl': imageUrl,
      };
    }

    // Fallback to fetching new verse if cache is incomplete
    return _fetchAndSaveNewVerse();
  }

  static Future<Map<String, dynamic>> _fetchAndSaveNewVerse() async {
    try {
      // Fetch verse from the same API as the widget
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

      // Fetch image
      final imageResponse = await http.get(
        Uri.parse(
          'https://api.unsplash.com/photos/random?query=nature,landscape&orientation=landscape',
        ),
        headers: {
          'Authorization':
              'Client-ID PHxdVOQofLiiK4IaORPHnxCLT2k49QLSV_SEPScYI5U',
        },
      );

      String? imageUrl;
      if (imageResponse.statusCode == 200) {
        final imageData = json.decode(imageResponse.body);
        imageUrl = imageData['urls']['regular'];
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      await prefs.setString(_verseTextKey, verseText);
      await prefs.setString(_verseReferenceKey, reference);
      if (imageUrl != null) {
        await prefs.setString(_backgroundImageUrlKey, imageUrl);
      }

      // Also save to UserDefaults for widget access
      await _saveToUserDefaults(verseText, reference, imageUrl ?? '');

      return {'verse': verseText, 'reference': reference, 'imageUrl': imageUrl};
    } catch (e) {
      print('Error fetching daily verse: $e');
      // Return default verse if fetch fails
      return {
        'verse':
            'For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.',
        'reference': 'John 3:16',
        'imageUrl': null,
      };
    }
  }

  static Future<void> _saveToUserDefaults(
    String verse,
    String reference,
    String imageUrl,
  ) async {
    try {
      await platform.invokeMethod('saveToAppGroup', {
        'verse': verse,
        'reference': reference,
        'imageUrl': imageUrl,
        'lastUpdate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving to UserDefaults: $e');
    }
  }
}

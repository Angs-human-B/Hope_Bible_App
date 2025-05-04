import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import '../Constants/app.constants.dart';

class PexelsService {
  static const String _baseUrl = 'https://api.pexels.com/v1';
  static const String _apiKey =
      'Sx04H7iuPh66EgbxSCakXVtI0Lvs08MkTfbOrBEPAAAc4Epwq2xebbUR'; // Replace with your API key

  static Future<String?> getDailyImage() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateTime = prefs.getString('last_image_update');
    final cachedImageUrl = prefs.getString('cached_image_url');

    // Check if we need to fetch a new image
    if (lastUpdateTime != null) {
      final lastUpdate = DateTime.parse(lastUpdateTime);
      final now = DateTime.now();
      if (now.difference(lastUpdate).inHours < 24 && cachedImageUrl != null) {
        return cachedImageUrl;
      }
    }

    try {
      // Get random search term
      final random = Random();
      final searchTerm =
          christianSearchTerms[random.nextInt(christianSearchTerms.length)];

      // Make API call
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search?query=${Uri.encodeComponent(searchTerm)}&per_page=50&page=1',
        ),
        headers: {'Authorization': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final photos = data['photos'] as List;

        if (photos.isNotEmpty) {
          // Get random photo from results
          final photo = photos[random.nextInt(photos.length)];
          final imageUrl = photo['src']['medium'];

          // Cache the new image URL and update time
          await prefs.setString('cached_image_url', imageUrl);
          await prefs.setString(
            'last_image_update',
            DateTime.now().toIso8601String(),
          );

          return imageUrl;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching Pexels image: $e');
      return cachedImageUrl; // Return cached image if available
    }
  }
}

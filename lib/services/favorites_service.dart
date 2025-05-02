import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../utilities/network.call.dart';
import '../favourites/models/favorite.model.dart';
import '../utilities/app.constants.dart';
import '../utilities/mixins.dart';
import '../media/models/media.model.dart' show Media;

class FavoritesController extends GetxController with RefreshToken {
  static FavoritesController get to => Get.find();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString error = "".obs;
  final RxList<FavoriteMedia> favorites = <FavoriteMedia>[].obs;
  final RxInt totalItems = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxString searchQuery = ''.obs;
  final RxList<FavoriteMedia> filteredFavorites = <FavoriteMedia>[].obs;
  final RxMap<String, bool> favoriteStatus = <String, bool>{}.obs;

  static const String _getFavoritesEndpoint = 'api/v1/favorites';
  static const String _toggleFavoriteEndpoint = 'api/v1/favorites';

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in search query and favorites list
    ever(searchQuery, (_) => _filterFavorites());
    ever(favorites, (_) {
      _filterFavorites();
      _updateFavoriteStatus();
    });
    // Initial load
    getFavorites();
  }

  void _updateFavoriteStatus() {
    // Clear existing status
    favoriteStatus.clear();
    // Update with current favorites
    for (var favorite in favorites) {
      favoriteStatus[favorite.media.id] = true;
    }
  }

  void _filterFavorites() {
    if (searchQuery.value.isEmpty) {
      filteredFavorites.value = favorites;
    } else {
      filteredFavorites.value =
          favorites.where((favorite) {
            return favorite.media.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
          }).toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  Future<void> getFavorites({int page = 1, int limit = 10}) async {
    try {
      isLoading(true);
      isError(false);
      error("");

      await _checkAuthToken();

      await getAPI(
        methodName: _getFavoritesEndpoint,
        callback: (value) {
          debugPrint("Get favorites response: ${value.response}");
          final Map<String, dynamic> data = json.decode(value.response);
          final response = FavoritesResponse.fromJson(data);

          favorites.value = response.favorites;
          totalItems.value = response.pagination.total;
          currentPage.value = response.pagination.page;
          totalPages.value = response.pagination.totalPages;
          _filterFavorites();
        },
      );
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      isError(true);
      error("Error fetching favorites");
    } finally {
      isLoading(false);
    }
  }

  Future<bool> toggleFavorite(String mediaId, {Media? mediaData}) async {
    try {
      // Get current status before updating
      final bool currentStatus = favoriteStatus[mediaId] ?? false;
      final int index = favorites.indexWhere((fav) => fav.media.id == mediaId);

      // Update local state immediately
      favoriteStatus[mediaId] = !currentStatus;

      if (!currentStatus && index == -1) {
        // If adding to favorites and not already in list
        favorites.add(
          FavoriteMedia(
            id: mediaId,
            userId: '', // Temporary value, will be updated after refresh
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
            v: 0,
            media: MediaContent(
              id: mediaId,
              title:
                  mediaData?.title ??
                  '', // Use provided media data if available
              thumbnail: mediaData?.thumbnail ?? '',
              url: mediaData?.signedUrl ?? '',
              fileType: mediaData?.fileType ?? '',
              tags: mediaData?.tags ?? [],
              featured: false,
            ),
          ),
        );
      } else if (currentStatus && index != -1) {
        // If removing from favorites
        // favorites.removeAt(index);
      }

      await _checkAuthToken();
      final success = await _toggleFavoriteAPI(mediaId);

      if (!success) {
        // Revert local changes if API call failed
        // favoriteStatus[mediaId] = currentStatus;
        if (!currentStatus && index == -1) {
          // favorites.removeWhere((fav) => fav.media.id == mediaId);
        } else if (currentStatus && index != -1) {
          // Re-add the item if we removed it
          await getFavorites(page: currentPage.value);
        }
        return false;
      }

      // Only refresh if we don't have complete media data
      if (mediaData == null) {
        // Refresh the list in the background without showing loading indicator
        final wasLoading = isLoading.value;
        isLoading.value = false;
        await getFavorites(page: currentPage.value);
        isLoading.value = wasLoading;
      }

      return true;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      isError(true);
      error("Error toggling favorite");
      return false;
    }
  }

  Future<bool> _toggleFavoriteAPI(String mediaId) async {
    try {
      bool success = false;
      await getAPI(
        methodName: "$_toggleFavoriteEndpoint/$mediaId",
        callback: (value) {
          final Map<String, dynamic> data = json.decode(value.response);
          success = data['success'] ?? false;
        },
      );
      return success;
    } catch (e) {
      debugPrint('Error in toggle favorite API: $e');
      return false;
    }
  }

  bool isFavorite(String mediaId) {
    return favoriteStatus[mediaId] ?? false;
  }

  Future<bool> checkIsFavorite(String mediaId) async {
    try {
      return favorites.any((fav) => fav.media.id == mediaId);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }

  Future<void> loadMoreFavorites() async {
    if (isLoading.value || currentPage.value >= totalPages.value) return;

    try {
      isLoading(true);
      isError(false);
      error("");

      await _checkAuthToken();

      await getAPI(
        methodName: _getFavoritesEndpoint,
        callback: (value) {
          debugPrint("Get favorites response: ${value.response}");
          final Map<String, dynamic> data = json.decode(value.response);
          final response = FavoritesResponse.fromJson(data);

          // Append new favorites to existing list
          favorites.addAll(response.favorites);
          totalItems.value = response.pagination.total;
          currentPage.value = response.pagination.page;
          totalPages.value = response.pagination.totalPages;
          _filterFavorites();
        },
      );
    } catch (e) {
      debugPrint('Error loading more favorites: $e');
      isError(true);
      error("Error loading more favorites");
    } finally {
      isLoading(false);
    }
  }
}

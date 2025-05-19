import 'dart:convert' show json;
import 'package:get/get.dart';
import 'package:hope/utilities/mixins.dart';
import '../../utilities/app.constants.dart' show AppConstants, Utils;
import '../../utilities/network.call.dart' show getAPI;
import 'package:hope/media/models/media.model.dart';
import 'package:flutter/material.dart';

class MediaController extends GetxController with RefreshToken {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString error = "".obs;
  RxBool isLoadingMore = false.obs;

  // Media list and pagination
  final mediaList = <Media>[].obs;
  final totalItems = 0.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final hasMorePages = true.obs;

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  RxString getMedia = "api/v1/media/".obs;

  Future getMediaFn(
    Map<String, dynamic> params,
    context, {
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (isLoadingMore.value || !hasMorePages.value) return;
      isLoadingMore.value = true;
    } else {
      isLoading(true);
    }

    isError(false);
    error("");

    try {
      await _checkAuthToken();

      // Add pagination parameters to URL
      final queryParams = {
        ...params,
        'page': currentPage.value,
        'limit': 10, // Adjust limit as needed
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final url =
          queryString.isNotEmpty
              ? '${getMedia.value}?$queryString'
              : getMedia.value;

      await getAPI(
        methodName: url,
        callback: (value) async {
          try {
            final Map<String, dynamic> valueMap = json.decode(value.response);
            Utils.logger.f("Media Map ${valueMap['media']}");

            if (valueMap.containsKey("media")) {
              final mediaResponse = MediaResponse.fromJson(valueMap);

              if (loadMore) {
                mediaList.addAll(mediaResponse.media);
              } else {
                mediaList.value = mediaResponse.media;
              }

              totalItems.value = mediaResponse.total;
              currentPage.value = mediaResponse.page;
              totalPages.value = mediaResponse.totalPages;
              hasMorePages.value = currentPage.value < totalPages.value;
            } else {
              isError(true);
              error(valueMap["message"] ?? "No media found");
            }
          } catch (e) {
            Utils.logger.e("Error parsing media response: $e");
            isError(true);
            error("Error parsing media data");
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
      isError(true);
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading(false);
      }
    }
  }

  Future<void> loadMoreMedia(BuildContext context) async {
    if (!hasMorePages.value || isLoadingMore.value) return;

    currentPage.value++;
    await getMediaFn({}, context, loadMore: true);
  }

  void resetPagination() {
    currentPage.value = 1;
    hasMorePages.value = true;
    mediaList.clear();
  }
}

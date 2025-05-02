import 'dart:convert' show json;
import 'package:get/get.dart';
import 'package:hope/utilities/mixins.dart';
import '../../utilities/app.constants.dart' show AppConstants, Utils;
import '../../utilities/network.call.dart' show getAPI;
import 'package:hope/media/models/media.model.dart';

class MediaController extends GetxController with RefreshToken {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString error = "".obs;

  // Media list and pagination
  final mediaList = <Media>[].obs;
  final totalItems = 0.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  RxString getMedia = "api/v1/media/".obs;

  Future getMediaFn(Map<String, dynamic> params, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await getAPI(
        methodName: getMedia.value,
        callback: (value) async {
          try {
            final Map<String, dynamic> valueMap = json.decode(value.response);
            Utils.logger.f("Media Map ${valueMap['media']}");

            if (valueMap.containsKey("media")) {
              final mediaResponse = MediaResponse.fromJson(valueMap);
              mediaList.value = mediaResponse.media;

              // Utils.logger.f('Media List Value ${mediaList}');
              totalItems.value = mediaResponse.total;
              currentPage.value = mediaResponse.page;
              totalPages.value = mediaResponse.totalPages;
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
      isLoading(false);
    }
  }
}

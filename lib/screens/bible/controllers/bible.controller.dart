// ignore_for_file: unused_element

import 'dart:convert' show json;

import '../../../utilities/app.constants.dart' show AppConstants, Utils;
import '../../../utilities/mixins.dart' show RefreshToken;
import 'package:get/get.dart';

import '../../../utilities/network.call.dart' show getAPI;
import '../models/bible.models.dart' show BibleTranslationResponse;

class BibleController extends GetxController with RefreshToken {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString error = "".obs;

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  String getAllBibleVersions = "api/v1/bible/versions";

  Future getAllBibleVersionsFn(context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      // await _checkAuthToken();
      await getAPI(
        methodName: getAllBibleVersions,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = BibleTranslationResponse.fromJson(valueMap);

            Utils.logger.f(response.data.length);

            Utils.logger.f(response.data.map((e) => e.name));
            // final UserResponse userResponse = UserResponse.fromJson(valueMap);
            // UserData userData = userResponse.data;
            // userDetails = userData;
            // Utils.logger.f(userData.taste);
          } else {
            isError(true);
            error(valueMap["message"]);
            isLoading(false);
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}

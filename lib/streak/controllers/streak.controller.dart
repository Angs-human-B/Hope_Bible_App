import 'dart:convert' show json;

import 'package:get/get.dart';
import 'package:hope/utilities/mixins.dart';

import '../../utilities/app.constants.dart' show AppConstants, Utils;
import '../../utilities/network.call.dart' show getAPI, multiPostAPINew, putAPI;
import '../models/streak.model.dart';

class StreakController extends GetxController with RefreshToken {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString error = "".obs;

  // Streak data observables
  RxInt currentStreak = 0.obs;
  RxInt longestStreak = 0.obs;
  Rx<DateTime?> lastUpdatedStreakDate = Rx<DateTime?>(null);
  RxString streakMessage = "".obs;
  RxString currentReadingTime = "".obs;

  RxList<DateTime> streakDates = <DateTime>[].obs;

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  RxString streak = "api/v1/streak".obs;
  RxString streakUpdate = "api/v1/streak/update".obs;
  RxString getStreak = "api/v1/streak/status".obs;
  RxString getStreakHistory = "api/v1/streak/history".obs;

  RxString readingTime = "api/v1/streak/reading-time".obs;

  Future updateStreakFn(Map<String, dynamic> params, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await multiPostAPINew(
        methodName: streakUpdate.value,
        param: params,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = StreakResponse.fromJson(valueMap["data"]);
            currentStreak.value = response.currentStreak;
            longestStreak.value = response.longestStreak;
            lastUpdatedStreakDate.value = response.lastUpdatedStreakDate;
            streakMessage.value = response.message;
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

  Future getStreakFn(Map<String, dynamic> params, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await getAPI(
        methodName:
            "${getStreak.value}?localDate=${DateTime.now().toIso8601String()}",
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = StreakResponse.fromJson(valueMap["data"]);
            currentStreak.value = response.currentStreak;
            longestStreak.value = response.longestStreak;
            lastUpdatedStreakDate.value = response.lastUpdatedStreakDate;
            streakMessage.value = response.message;
            currentReadingTime.value = response.readingTime ?? '';
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

  Future getStreakHistoryFn(Map<String, dynamic> params, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await getAPI(
        methodName: getStreakHistory.value,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          Utils.logger.f("Streak History valueMap: $valueMap");
          if (valueMap["success"] == true) {
            final response = StreakHistoryResponse.fromJson(valueMap["data"]);
            streakDates.value = response.streakDates;
            Utils.logger.f("Streak History streakDates: $streakDates");
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

  Future updateReadingTimeFn(Map<String, dynamic> params, context) async {
    try {
      // isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await putAPI(
        methodName: readingTime.value,
        param: params,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = ReadingTimeResponse.fromJson(valueMap["data"]);
            currentReadingTime.value = response.readingTime;
            streakMessage.value = response.message;
          } else {
            isError(true);
            error(valueMap["message"]);
            isLoading(false);
          }
        },
      );
    } catch (ex) {
      error("something went wrong");
      // isLoading(false);
    } finally {
      // isLoading(false);
    }
  }
}

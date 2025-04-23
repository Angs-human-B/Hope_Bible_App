import 'dart:convert' show json;

import 'package:get/get.dart';
import 'package:hope/utilities/network.call.dart';

import '../../../utilities/app.constants.dart' show AppConstants;
import '../../../utilities/mixins.dart' show RefreshToken;
import '../models/chat.model.dart';

class ChatController extends GetxController with RefreshToken {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString error = "".obs;
  // RxList<BibleBook> bibleBooks = <BibleBook>[].obs;
  RxString newSession = "api/v1/chat/session".obs;
  RxString sendMessage = "api/v1/chat/chat".obs;
  RxString sessionId = "".obs;
  RxString currentResponse = "".obs;
  RxList<String> scriptureReferences = <String>[].obs;
  RxString additionalInsights = "".obs;
  RxString prayerSuggestion = "".obs;

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  Future createSessionFn(Map<String, dynamic> params, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await multiPostAPINew(
        methodName: newSession.value,
        param: params,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = ChatSessionResponse.fromJson(valueMap);
            sessionId.value = response.data.id;
            print("Session created with ID: ${sessionId.value}");
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

  Future sendMessageFn(String message) async {
    if (sessionId.isEmpty) {
      error("No active chat session");
      return;
    }

    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();

      Map<String, dynamic> params = {
        "sessionId": sessionId.value,
        "message": message,
        "userId": AppConstants.userId,
      };

      await multiPostAPINew(
        methodName: sendMessage.value,
        param: params,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["success"] == true) {
            final response = ChatMessageResponse.fromJson(valueMap);
            currentResponse.value = response.data.answer;
            scriptureReferences.value = response.data.scriptureReferences;
            additionalInsights.value = response.data.additionalInsights;
            prayerSuggestion.value = response.data.prayerSuggestion;
            print("Message sent successfully: ${response.data.answer}");
          } else {
            isError(true);
            error(valueMap["message"]);
            isLoading(false);
          }
        },
      );
    } catch (ex) {
      error("Failed to send message");
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}

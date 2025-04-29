// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hope/screens/home_screen.dart';
import 'package:hope/utilities/app.constants.dart' show AppConstants, Utils;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utilities/mixins.dart' show RefreshToken;
import '../../../utilities/network.call.dart'
    show getAPI, multiPostAPINew, patchAPI;
import '../../../utilities/text.utility.dart' show AllText;
import '../../../utilities/toast.widget.dart' show showErrorToast;
import '../../onboarding/onboarding_screen_pageview.dart' show OnboardingPager;
import '../models/user.model.dart' show User, UserData, UserResponse;

class SignUpController extends GetxController with RefreshToken {
  Offerings? offerings;

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString error = "".obs;
  RxBool updateEmailPassword = false.obs;
  String updateUser = "api/user";
  String getUserValue = "api/user";
  String checkRevenueCatSubscription = "api/user/revenueCat";
  String registerUser = "api/v1/auth/register";
  String deleteUser = "api/user/delete";
  String userLogin = "api/v1/auth/login";
  UserData userDetails = UserData.empty();

  Future getUserDetailsFn(String userId, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await getAPI(
        methodName: "$getUserValue/$userId",
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["statusCode"] == 201) {
            final UserResponse userResponse = UserResponse.fromJson(valueMap);
            UserData userData = userResponse.data;
            userDetails = userData;
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

  Future matchRevenueCatID(String revenueCatID, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await getAPI(
        methodName: "$checkRevenueCatSubscription/$revenueCatID",
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["statusCode"] == 201) {
            AppConstants.existingUser = true;
            // final UserResponse userResponse = UserResponse.fromJson(valueMap);
            // UserData userData = userResponse.data;
            // userDetails = userData;
            Utils.logger.f(valueMap['data']);
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

  Future userRegisterFn(Map<String, dynamic> param, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await multiPostAPINew(
        methodName: registerUser,
        param: param,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          Utils.logger.e('User registered Value --_---->>> $valueMap');
          if (valueMap["statusCode"] == 201) {
            SharedPreferences sp = await SharedPreferences.getInstance();
            Utils.logger.e(
              'Constants auth token ${valueMap['data']['accessToken']}',
            );

            AppConstants.email = valueMap['data']["email"];
            AppConstants.name = valueMap['data']["name"];
            AppConstants.userId = valueMap['data']["_id"];
            AppConstants.authToken = valueMap['data']['accessToken'];

            // sp.setString('authToken', valueMap['data']['accessToken']);
            // sp.setString('userId', valueMap['data']["_id"]);
            // sp.setString('name', valueMap['data']["name"] ?? '');
            // sp.setString('email', valueMap['data']["email"]);

            sp.setString('authToken', valueMap['data']['accessToken']);
            sp.setString('userId', valueMap['data']['_id']);
            sp.setString('name', valueMap['data']['name']);
            sp.setString('email', valueMap['data']['email']);
            // User user = User.fromJson(valueMap['data']['user']);

            Utils.logger.e('Constants auth token ${AppConstants.authToken}');

            Utils.logger.e('Prefs auth token ${sp.getString('accessToken')}');

            Utils.logger.e('Prefs userId ${sp.getString('userId')}');

            // await setUserData(user);

            Utils.logger.i(valueMap);
            await Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) => CupertinoScaffold(body: HomeScreen()),
              ),
            );
          } else {
            showErrorToast(
              context: context,
              title: "Unable to sign up",
              description: "User already exists, please login.",
            );
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

  Future<void> userUpdateFn(
    Map<String, dynamic> param,
    BuildContext context,
    bool? preferenceChanged,
  ) async {
    try {
      // Indicate that the loading process has started
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await patchAPI(
        methodName: updateUser,
        param: param,
        callback: (value) async {
          Utils.logger.d(param);
          Map<String, dynamic> valueMap = json.decode(value.response);

          if (valueMap["statusCode"] == 201) {
            // Show success toast
            // CachedQuery.instance.storage?.delete('specialTabQuery');
            // if (preferenceChanged == true) {
            //   CachedQuery.instance.invalidateCache(key: 'specialTabQuery');
            //   CachedQuery.instance.invalidateCache(key: 'breakfastTabQuery');
            //   CachedQuery.instance.invalidateCache(key: 'lunchTabQuery');
            //   CachedQuery.instance.invalidateCache(key: 'dinnerTabQuery');
            //   CachedQuery.instance.invalidateCache(key: 'snacksTabQuery');
            //   CachedQuery.instance.invalidateCache(key: 'drinksTabQuery');
            //   CachedQuery.instance.invalidateCache(key: 'dessertsTabQuery');
            // }

            Utils.logger.i(valueMap);
          } else {
            // Handle error response from API
            isError(true);
            error(valueMap["message"] ?? "An unexpected error occurred.");

            // Show error toast with the message from the API
            showErrorToast(
              context: context,
              title: "Update Failed",
              description:
                  valueMap["message"] ??
                  "Something went wrong. Please try again.",
            );
          }

          // Stop the loading indicator after processing the response
          isLoading(false);
        },
      );
    } catch (ex) {
      // Handle any exceptions that occur during the API call
      isError(true);
      error("Something went wrong");

      // Show a generic error toast for exceptions
      showErrorToast(
        context: context,
        title: "Error",
        description: "Something went wrong. Please try again.",
      );

      // Stop the loading indicator in case of an exception
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future userLoginFn(Map<String, dynamic> param, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await multiPostAPINew(
        methodName: userLogin,
        param: param,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);

          if (valueMap["success"] == true) {
            SharedPreferences sp = await SharedPreferences.getInstance();

            Utils.logger.e(
              'Constants auth token ${valueMap['data']['user']["_id"]}',
            );

            sp.setString('userId', valueMap['data']['user']["_id"]);
            sp.setString('authToken', valueMap['data']['token']);
            sp.setString('name', valueMap['data']['user']['name']);

            AppConstants.authToken = valueMap['data']['token'];
            User user = User.fromJson(valueMap['data']['user']);

            Utils.logger.e('Prefs auth token ${sp.getString('token')}');

            Utils.logger.e('Prefs userId ${sp.getString('userId')}');

            await setUserData(user);

            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder:
                    (context) => CupertinoScaffold(body: const HomeScreen()),
              ),
            );
            Utils.logger.e(AppConstants.authToken);
          } else {
            showCupertinoDialog(
              context: context,
              builder:
                  (context) => CupertinoAlertDialog(
                    title: const AllText(text: "Account Not Found"),
                    content: const AllText(
                      text:
                          "No account was found. Would you like to create one?",
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const AllText(text: "Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: AllText(text: "Register"),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: false).push(
                            CupertinoPageRoute(
                              builder:
                                  (context) => const CupertinoScaffold(
                                    body: OnboardingPager(),
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
            );
            // showErrorToast(
            //   context: context,
            //   title: "This user does not exist.",
            //   description: "Please go back and register.",
            // );
            isError(true);
            error(valueMap["message"]);
            // handleError(valueMap["message"], context);
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

  Future userDeleteFn(Map<String, dynamic> param, context) async {
    try {
      isLoading(true);
      isError(false);
      error("");
      await _checkAuthToken();
      await multiPostAPINew(
        methodName: deleteUser,
        param: param,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);

          if (valueMap["success"] == true) {
            SharedPreferences sp = await SharedPreferences.getInstance();

            String? authToken = sp.getString('authToken') ?? "";
            AppConstants.authToken = authToken;
            String? userId = sp.getString('userId') ?? "";
            showCupertinoDialog(
              context: context,
              builder:
                  (context) => CupertinoAlertDialog(
                    title: const Text("Account Deleted"),
                    content: Text(
                      "Your account has been successfully deleted.\nReason: ${param['description']}",
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("OK"),
                        onPressed: () {
                          destroyData(context);
                        },
                      ),
                    ],
                  ),
            );
          } else {
            showCupertinoDialog(
              context: context,
              builder:
                  (context) => CupertinoAlertDialog(
                    title: const Text("Error"),
                    content: const Text(
                      "There was an error deleting your account. Please try again.",
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
            );
            isError(true);
            error(valueMap["message"]);
            // handleError(valueMap["message"], context);
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

  Future<void> _checkAuthToken() async {
    if (AppConstants.authToken.isNotEmpty) {
      await tokenRefresh();
    }
  }

  setUserData(User obj) {
    AppConstants.userId = obj.id;
    AppConstants.name = obj.name;
    AppConstants.email = obj.email;
    AppConstants.appleId = obj.appleId;
  }
}

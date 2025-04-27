import 'dart:convert';
import 'dart:developer';
import 'package:hope/utilities/app.constants.dart' show AppConstants, Utils;
import 'package:shared_preferences/shared_preferences.dart';
import 'network.call.dart' show multiPostAPINew;
import 'package:jwt_decoder/jwt_decoder.dart';

mixin RefreshToken {
  tokenRefresh() async {
    bool isTokenExpired = JwtDecoder.isExpired(AppConstants.authToken);
    Utils.logger.e('Is JWT expired $isTokenExpired');
    if (isTokenExpired) {
      String token = await refreshToken();
      AppConstants.authToken = token;
      log("refresh token===${AppConstants.authToken}");
    }
  }

  String fetchToken = "api/v1/auth/access-token";
  Future<String> refreshToken() async {
    String authToken = "";
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await multiPostAPINew(
        param: {"accessToken": AppConstants.authToken},
        methodName: fetchToken,
        callback: (value) async {
          Map<String, dynamic> valueMap = json.decode(value.response);
          Utils.logger.e('ValueMap Type ---> ${valueMap.runtimeType}');
          if (valueMap.containsKey('data')) {
            prefs.setString('authToken', valueMap["data"]);
            Utils.logger.e('Access token fetched ---> ${valueMap['data']}');
            AppConstants.authToken = valueMap["data"];
            authToken = valueMap["data"];
          } else {
            throw valueMap["message"];
          }
        },
      );
      return authToken;
    } catch (ex) {
      throw ex.toString();
    }
  }

  destroyData(context) async {
    AppConstants.userId = "";
    AppConstants.name = "";
    AppConstants.authToken = "";
    AppConstants.email = "";
    AppConstants.username = "";

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('userId');
    sp.remove('authToken');
    sp.remove('name');
    sp.remove('email');
    // CachedQuery.instance.invalidateCache();
    // Navigator.of(context, rootNavigator: false).push(
    //   CupertinoPageRoute(
    //     builder: (context) => WillPopScope(
    //       onWillPop: () async => false,
    //       child: const CupertinoScaffold(body: WelcomeScreen1()),
    //     ),
    //   ),
    // );
  }
}

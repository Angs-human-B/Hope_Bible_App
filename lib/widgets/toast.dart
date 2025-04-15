import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> toast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 2,
    // backgroundColor: AllColors.black,
    // textColor: AllColors.white,
    fontSize: 14.0,
  );
}

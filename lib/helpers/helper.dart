import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

String baseUrl = "http://api.yarazon.com/api/";
String baseUrlWithoutApi = "http://api.yarazon.com/";
final storage = GetStorage();
String userToken = 'userToken';
String isUserLogin = 'isUserLogin';
String selectedLang = 'selectedLang';
String completeUser = 'completeUser';
String imagUrl = "../assets/imgs/profile.png";
//"https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
var logger = Logger();
var selectedLanguage = Get.locale?.languageCode.obs;
Color primaryColor = Color(0xFFf39423);
var Token = storage.read('userToken');
var userId = storage.read('userId');
var userInfo = storage.read('completeUser');
String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '۷', '۸', '۹'];
  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], farsi[i]);
  }
  return input;
}

showMessage(
  String data, {
  double fontsize = 16.0,
}) {
  Fluttertoast.showToast(
    msg: data,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.greenAccent,
    textColor: Color(0xffffffff),
    fontSize: fontsize,
  );
}

showErrorMessage(
  String data, {
  double fontsize = 16.0,
}) {
  Fluttertoast.showToast(
    msg: data,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.redAccent,
    textColor: Color(0xffffffff),
    fontSize: fontsize,
  );
}

getHeaderNoAuth() {
  selectedLanguage = Get.locale?.languageCode.obs;
  return {
    "Accept": "application/json",
    "Content-Type": "application/json",
    'Access-Control-Allow-Origin': '*',
    'App-Language': '${selectedLanguage.obs}',
  };
}

getHeaderAuth() {
  selectedLanguage = Get.locale?.languageCode.obs;
  return {
    "Accept": "application/json",
    "Content-Type": "application/json",
    'Access-Control-Allow-Origin': '*',
    'App-Language': '${selectedLanguage.obs}',
    "Authorization": "Bearer ${storage.read(userToken)}",
    "Token": "Bearer ${storage.read(userToken)}"
  };
}

getHeaderAuthWithFile() {
  selectedLanguage = Get.locale?.languageCode.obs;
  return {
    "Content-Type": "multipart/form-data",
    "Accept": "application/json",
    'Access-Control-Allow-Origin': '*',
    'App-Language': '${selectedLanguage.obs}',
    "Authorization": "Bearer ${storage.read(userToken)}",
    "Token": "Bearer ${storage.read(userToken)}"
  };
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

class Skelton extends StatelessWidget {
  const Skelton({this.height, this.width});
  final double? height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(16))));
  }
}

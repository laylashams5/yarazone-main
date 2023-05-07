import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/constants.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/helpers/splash.dart';
import 'package:yarazon/screens/change-password.dart';
import 'package:yarazon/screens/edit-profile.dart';
import 'package:yarazon/screens/favorite.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/orders-history.dart';
import 'package:yarazon/services/api.dart';
import 'dart:ui' as ui;

class ProfileScreen extends StatefulWidget {
  bool isLoginForm;
  ProfileScreen({this.isLoginForm = false});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = false;
  bool isLoading = false;

  var userData;
  @override
  void initState() {
    super.initState();
    setState(() {
      getUserInfo();
    });
    Token = storage.read('userToken');
    print(userInfo);
  }

  @override
  Widget build(BuildContext context) {
    var selectedLanguage = Get.locale?.languageCode.obs;
    print('selectedLanguage $selectedLanguage');
    final List locales = [
      {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
      {'name': 'لغة عربية', 'locale': Locale('ar', 'SD')},
    ];
    updateLanguage(Locale locale) {
      Get.updateLocale(locale);
      Get.to(SplashScreen());
    }

    //ar_SD en_US
    _chooseLanguage(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {},
      );
      AlertDialog alert = AlertDialog(
        backgroundColor: primaryColor,
        title: Container(
          child: Text(
            'Choose Your Language'.tr,
            style: TextStyle(
              fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
              fontSize: 16,
              color: Color(0xff333333),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Directionality(
          textDirection:
              selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            width: double.maxFinite,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text(
                        locales[index]['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          color: Color(0xff333333),
                        ),
                      ),
                      onTap: () async {
                        updateLanguage(locales[index]['locale']);
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xff333333), width: 0.4))),
                  );
                },
                itemCount: locales.length),
          ),
        ),
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(15),
              child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: alert));
        },
      );
    }

    return SingleChildScrollView(
        child: Directionality(
            textDirection: selectedLanguage == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Container(
                color: const Color(0xfffbfbfb),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(children: [
                  Row(
                    children: [
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                decoration:
                                    new BoxDecoration(color: Colors.white),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: imagUrl,
                                    width: 80,
                                    height: 80,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error, color: primaryColor),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                        value: downloadProgress.progress,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection: TextDirection.rtl,
                            children: [
                              Container(
                                child: Text(
                                  '${userData != null ? userData['name'] : 'Full Name'.tr}',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: selectedLanguage == 'en'
                                          ? 'lucymar'
                                          : 'LBC'),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(EditProfileScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(5.0)),
                      margin: EdgeInsets.only(
                        top: 25,
                      ),
                      child: Row(
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account Info'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontWeight: FontWeight.w600,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.left,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            color: Color(0xff333333),
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(ChangePasswordScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(5.0)),
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      child: Row(
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change Password'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontWeight: FontWeight.w600,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.left,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff333333),
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (Token != null)
                    GestureDetector(
                      onTap: () {
                        Get.to(FavoriteScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(5.0)),
                        margin: EdgeInsets.only(
                          top: 15,
                        ),
                        child: Row(
                          textDirection: selectedLanguage == 'en'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Favorite'.tr,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: selectedLanguage == 'en'
                                      ? 'lucymar'
                                      : 'LBC'),
                              textAlign: selectedLanguage == 'en'
                                  ? TextAlign.left
                                  : TextAlign.left,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff333333),
                              textDirection: selectedLanguage == 'en'
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      Get.to(OrdersHistoryScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(5.0)),
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      child: Row(
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Orders History'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontWeight: FontWeight.w600,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.left,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff333333),
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     padding: EdgeInsets.all(15),
                  //     decoration: BoxDecoration(
                  //         color: Color(0xffffffff),
                  //         borderRadius: BorderRadius.circular(5.0)),
                  //     margin: EdgeInsets.only(
                  //       top: 15,
                  //     ),
                  //     child: Row(
                  //       textDirection: selectedLanguage == 'en'
                  //           ? TextDirection.ltr
                  //           : TextDirection.rtl,
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           'Notifications'.tr,
                  //           style: TextStyle(
                  //               color: Color(0xff333333),
                  //               fontWeight: FontWeight.w600,
                  //               fontFamily: selectedLanguage == 'en'
                  //                   ? 'lucymar'
                  //                   : 'LBC'),
                  //           textAlign: selectedLanguage == 'en'
                  //               ? TextAlign.left
                  //               : TextAlign.left,
                  //         ),
                  //         Directionality(
                  //           textDirection: selectedLanguage == 'en'
                  //               ? TextDirection.ltr
                  //               : TextDirection.rtl,
                  //           child: Container(
                  //             height: 20,
                  //             width: 35,
                  //             decoration: BoxDecoration(
                  //                 color: isSwitched
                  //                     ? primaryColor
                  //                     : Colors.transparent,
                  //                 borderRadius: BorderRadius.circular(100)),
                  //             child: Switch(
                  //               materialTapTargetSize:
                  //                   MaterialTapTargetSize.shrinkWrap,
                  //               value: isSwitched,
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   isSwitched = value;
                  //                 });
                  //               },
                  //               activeTrackColor: primaryColor,
                  //               activeColor: Color(0xffffffff),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(5.0)),
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      child: Row(
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Language'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontWeight: FontWeight.w600,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.left,
                          ),
                          GestureDetector(
                            onTap: () {
                              _chooseLanguage(context);
                            },
                            child: Text(
                              selectedLanguage == 'en'
                                  ? 'English'.tr
                                  : 'Arabic'.tr,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: selectedLanguage == 'en'
                                      ? 'lucymar'
                                      : 'LBC'),
                              textDirection: selectedLanguage == 'en'
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      logout();
                      await CometChat.logout(
                          onError: (CometChatException exception) {},
                          onSuccess: (Map<String, Map<String, int>> message) {
                            print('logout $message');
                            USERID = "";
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      child: Row(
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Logout'.tr,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  isLoading == true
                      ? Container(
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.only(left: 100, right: 100, top: 0),
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: primaryColor,
                            size: 20,
                          ),
                        )
                      : Text(''),
                ]))));
  }

  Future getUserInfo() async {
    isLoading = true;
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('me', headers: headers);
    if (Token != null) {
      setState(() {
        isLoading = false;
      });
      value = json.decode(value);
      value = value['data'];
      userData = value;
      // await storage.write(completeUser, userData);
      print("userData $userData");
    }
  }

  Future logout() async {
    var value = await ApiServices.postApi('logout', headers: getHeaderAuth());
    var decode = json.decode(value);
    print(decode);
    if (Token != null) {
      setState(() {
        isLoading = false;
      });
      await storage.erase();
      showMessage('Log out Successfully'.tr);
      Get.offAll(HomeScreen());
    } else {
      setState(() {
        isLoading = false;
      });
      logger.e(value);
    }
  }
}

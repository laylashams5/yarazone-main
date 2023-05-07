import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/constants.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/categories.dart';
import 'package:yarazon/screens/contact-us.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/orders-history.dart';
import 'package:yarazon/screens/products.dart';
import 'package:yarazon/services/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yarazon/widgets/product-categories.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool isLoading = false;
  var userData;
  @override
  void initState() {
    super.initState();
    getUserInfo();
    Token = storage.read('userToken');
    print('products $products');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        width: 220,
        child: Drawer(
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 45, 52, 63),
            ),
            child: ListView(
              children: [
                Container(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Stack(
                            alignment: selectedLanguage == 'en'
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            fit: StackFit.loose,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ]))),
                if (Token != null)
                  Container(
                      margin: EdgeInsets.only(right: 20, left: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: CachedNetworkImage(
                                imageUrl: imagUrl,
                                width: 50,
                                height: 50,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, color: primaryColor),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    value: downloadProgress.progress,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                '${userData != null ? userData['name'] : 'Full Name'.tr}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ])),
                if (Token != null)
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Wallet'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xffffffff),
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.only(left: 5, right: 5),
                          margin: EdgeInsets.only(left: 3, bottom: 3, right: 3),
                          child: Text(
                            '${userData != null ? userData['wallet'] : '0.00'}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xffffffff),
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (Token == null)
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                    ),
                    child: Image.asset(
                      'assets/imgs/yara-logo-white.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color(0xffcccccc),
                    width: 0.2,
                  ))),
                ),
                ListTile(
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    leading: Icon(Icons.home_outlined, color: primaryColor),
                    title: Text(
                      'Home'.tr,
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }),
                ListTile(
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    leading:
                        Icon(Icons.grid_view_outlined, color: primaryColor),
                    title: Text(
                      'Categories'.tr,
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesScreen()),
                      );
                    }),
                ListTile(
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    leading: Icon(Icons.auto_awesome_mosaic_outlined,
                        color: primaryColor),
                    title: Text(
                      'Products'.tr,
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsCategories(
                                  products: products,
                                )),
                      );
                    }),
                if (Token != null)
                  ListTile(
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading:
                          Icon(Icons.list_alt_outlined, color: primaryColor),
                      title: Text(
                        'Orders History'.tr,
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersHistoryScreen()),
                        );
                      }),
                ListTile(
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    leading: Icon(Icons.contacts_outlined, color: primaryColor),
                    title: Text(
                      'Contact US'.tr,
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                    ),
                    onTap: () {
                      //contactUrl();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsScreen()),
                      );
                    }),
                if (Token != null)
                  ListTile(
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Icon(Icons.power_settings_new_outlined,
                          color: Colors.red),
                      title: Text(
                        'Logout'.tr,
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                      onTap: () async {
                        logout();
                        await CometChat.logout(
                            onError: (CometChatException exception) {},
                            onSuccess: (Map<String, Map<String, int>> message) {
                              print('logout $message');
                              USERID = "";
                            });
                      }),
                if (Token == null)
                  ListTile(
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Icon(Icons.login, color: Colors.red),
                      title: Text(
                        'Sign in'.tr,
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                      onTap: () async {
                        print('loooogin');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    isLoginForm: true,
                                  )),
                        );
                      }),
                isLoading == true && Token != null
                    ? Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: primaryColor,
                          size: 30,
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  contactUrl() async {
    const url = 'https://yarazon.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      // print('userData ${userData}');
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

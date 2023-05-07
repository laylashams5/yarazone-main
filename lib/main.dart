import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yarazon/helpers/change-language.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/helpers/splash.dart';
import 'package:get/get.dart';
import 'package:yarazon/screens/order-detials.dart';

import 'helpers/constants.dart';

void main() async {
  //primaryColor #f39423
  //secondaryColor #000
  await GetStorage.init();

  //CometChat SDk should be initialized at the start of application. No need to initialize it again
    AppSettings appSettings = (AppSettingsBuilder()
          ..subscriptionType = CometChatSubscriptionType.allUsers
          ..region = CometChatAuthConstants.region
          ..autoEstablishSocketConnection = true)
        .build();

    CometChat.init(CometChatAuthConstants.appId, appSettings,
        onSuccess: (String successMessage) {
      debugPrint("Initialization completed successfully  $successMessage");
    }, onError: (CometChatException excep) {
      debugPrint("Initialization failed with exception: ${excep.message}");
    });
    //initialization end
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'yarazon | يارازون',
    theme: ThemeData(
      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
      primaryColorDark: Colors.white,
      primaryColor: const Color(0xfff39423),
      primaryTextTheme: const TextTheme(
        caption: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.white),
      ),
    ),
    home: GetMaterialApp(
      locale: const Locale('ar', 'SD'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      translations: ChangeLanguage(),
      home: SplashScreen(),
      routes: {
        OrderDetailsScreen.routeName: (context) => OrderDetailsScreen(),
      },
    ),
  ));
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/helpers/splash.dart';
import 'package:yarazon/models/chat.dart';
import 'package:yarazon/screens/cart.dart';
import 'package:yarazon/screens/chat.dart';
import 'package:yarazon/screens/choose-department.dart';
import 'package:yarazon/screens/favorite.dart';
import 'package:yarazon/screens/filter.dart';
import 'package:yarazon/screens/login.dart';
import 'package:yarazon/screens/main-tab.dart';
import 'package:yarazon/screens/menu.dart';
import 'package:yarazon/screens/message-list.dart';
import 'package:yarazon/screens/products.dart';
import 'package:yarazon/screens/profile.dart';
import 'package:yarazon/screens/user-list.dart';
import 'package:yarazon/services/api.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:yarazon/helpers/constants.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  bool isLoginForm;
  HomeScreen({this.isLoginForm = false});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? tabIndex = 3;
  bool _showBootSheet = false;
  bool _selectedSort0 = false;
  bool _selectedSort1 = false;
  var userData;
  bool? firstMessage;
  late PersistentBottomSheetController _bottomcontroller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late List<Widget> tabScreens;
  var selectedLanguage = Get.locale?.languageCode.obs;
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

  List<Chat> oldMessages = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserInfo();

// //CometChat SDk should be initialized at the start of application. No need to initialize it again
//     AppSettings appSettings = (AppSettingsBuilder()
//           ..subscriptionType = CometChatSubscriptionType.allUsers
//           ..region = CometChatAuthConstants.region
//           ..autoEstablishSocketConnection = true)
//         .build();

//     CometChat.init(CometChatAuthConstants.appId, appSettings,
//         onSuccess: (String successMessage) {
//       debugPrint("Initialization completed successfully  $successMessage");
//     }, onError: (CometChatException excep) {
//       debugPrint("Initialization failed with exception: ${excep.message}");
//     });
//     //initialization end

    if (widget.isLoginForm == true) {
      setState(() {
        tabIndex == 3;
      });
    } else {
      tabIndex = 0;
    }
    Token = storage.read('userToken');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Conversation createConversation = Conversation(
      conversationType: ConversationType.user,
      conversationWith: User(name: 'botx',uid: 'botx'),
    );
    tabScreens = [
      MainTabScreen(),
      ProductsScreen(),
      CartScreen(),
      Token != null ? ProfileScreen() : LoginScreen(),
      if (Token != null) MessageListScreen(conversation: createConversation)
    ];
    return Directionality(
        textDirection:
            selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          backgroundColor: const Color(0xfffbfbfb),
          appBar: tabIndex == 0
              ? AppBar(
                  backgroundColor: Color(0xffeeeeee),
                  automaticallyImplyLeading: false,
                  title: Image.asset(
                    'assets/imgs/logo.png',
                    width: 70,
                    height: 70,
                  ),
                  centerTitle: true,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: Icon(Icons.more_vert_outlined,
                          color: Color(0xff333333))),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(children: [
                        if (Token != null)
                          GestureDetector(
                            onTap: () {
                              Get.to(FavoriteScreen());
                            },
                            child: Icon(
                              Icons.favorite_border,
                              color: Color(0xff333333),
                              size: 25,
                            ),
                          ),
                        Padding(padding: EdgeInsets.only(left: 3, right: 3)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tabIndex = 2;
                            });
                          },
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Color(0xff333333),
                            size: 25,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 3, right: 3)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _chooseLanguage(context);
                            });
                          },
                          child: Icon(
                            Icons.language_outlined,
                            color: Color(0xff333333),
                            size: 25,
                          ),
                        ),
                      ]),
                    ),
                  ],
                  toolbarHeight: 80,
                )
              : tabIndex == 3
                  ? AppBar(
                      automaticallyImplyLeading: false,
                      title: Text(
                        'My Account'.tr,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                      centerTitle: true,
                      toolbarHeight: 30,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    )
                  : tabIndex == 2
                      ? AppBar(
                          automaticallyImplyLeading: false,
                          title: Text(
                            'Cart'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 16,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                          ),
                          centerTitle: true,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        )
                      : tabIndex == 1
                          ? AppBar(
                              automaticallyImplyLeading: false,
                              title: Text(
                                'Products'.tr,
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 16,
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                              centerTitle: true,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              leading: IconButton(
                                  tooltip: 'Sort'.tr,
                                  icon: const Icon(
                                    Icons.sort,
                                    size: 20,
                                    color: Color(0xff3333333),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showBootSheet = true;
                                    });
                                    if (_showBootSheet = true) {
                                      _bottomcontroller = _scaffoldKey
                                          .currentState!
                                          .showBottomSheet(
                                        (_) => _showBottomSheet(),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(16),
                                                topLeft: Radius.circular(16))),
                                      );
                                    } else {
                                      _bottomcontroller.close();
                                    }
                                  }),
                              actions: [
                                IconButton(
                                  tooltip: 'Filter'.tr,
                                  icon: const Icon(
                                    Icons.search_outlined,
                                    size: 22,
                                    color: Color(0xff3333333),
                                  ),
                                  onPressed: () async {
                                    Get.to(FilterScreen());
                                  },
                                ),
                              ],
                            )
                          : null,
          drawer: Directionality(
              textDirection: selectedLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: MenuScreen()),
          body: Stack(
            children: [
              tabScreens[tabIndex!],
            ],
          ),
          bottomNavigationBar: tabIndex != 4
              ? Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    color: Color(0xffffffff),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: Colors.green,
                        primaryColor: Colors.red,
                        textTheme: Theme.of(context).textTheme.copyWith(
                            caption: new TextStyle(color: Colors.orange))),
                    child: BottomNavigationBar(
                        showUnselectedLabels: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: Color(0xfff39423),
                        unselectedItemColor: Color(0xffcccccc),
                        selectedLabelStyle: TextStyle(
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                        unselectedLabelStyle: TextStyle(
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                        iconSize: 25,
                        selectedFontSize: 14,
                        unselectedFontSize: 14,
                        currentIndex: tabIndex!,
                        onTap: (int index) {
                          setState(() {
                            tabIndex = index;
                          });
                        },
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined),
                            label: 'Home'.tr,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.auto_awesome_mosaic_outlined),
                            label: 'Products'.tr,
                          ),
                          BottomNavigationBarItem(
                            icon: new Stack(children: <Widget>[
                              new Icon(Icons.shopping_cart_outlined),
                              new Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: new Icon(Icons.brightness_1,
                                    size: 8.0, color: Colors.redAccent),
                              )
                            ]),
                            label: 'Cart'.tr,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline),
                            label: 'My Account'.tr,
                          ),
                          if (Token != null)
                            BottomNavigationBarItem(
                              icon: Icon(Icons.message_outlined),
                              label: 'Chat'.tr,
                            ),
                        ]),
                  ))
              : Text(''),
        ));
  }

  _showBottomSheet() {
    return tabIndex == 1 && _showBootSheet == true
        ? Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200, width: 0),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Sort".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xff333333),
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSort0 = !_selectedSort0;
                          if (_selectedSort0 == true) {
                            _selectedSort1 = false;
                          }
                          _bottomcontroller =
                              _scaffoldKey.currentState!.showBottomSheet(
                            (_) => _showBottomSheet(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16))),
                          );
                          products.sort((a, b) =>
                              a["price_sdg"].compareTo(b["price_sdg"]));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _selectedSort0 == false
                                ? Color(0xfff4f4f4)
                                : primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Price:'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                              ),
                              Text(
                                'lowest to high'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSort1 = !_selectedSort1;
                          if (_selectedSort1 == true) {
                            _selectedSort0 = false;
                          }
                          _bottomcontroller =
                              _scaffoldKey.currentState!.showBottomSheet(
                            (_) => _showBottomSheet(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16))),
                          );
                          products.sort((a, b) =>
                              b["price_sdg"].compareTo(a["price_sdg"]));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: _selectedSort1 == false
                                ? Color(0xfff4f4f4)
                                : primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Price:'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                              ),
                              Text(
                                'highest to low'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //clear
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 36,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xfff4f4f4), width: 1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Clear'.tr,
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 14,
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC',
                                    fontWeight: FontWeight.w500)),
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )),
              ],
            ),
          )
        : null;
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
      storage.write('userId', userData['id']);
      userId = storage.read('userId');
    }
  }
}

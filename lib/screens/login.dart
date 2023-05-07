import 'dart:convert';

import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/constants.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/forgot-password.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/register.dart';
import 'package:yarazon/services/api.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  var selectedLanguage = Get.locale?.languageCode.obs;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool isLoginForm = true;
  bool isRegisterForm = false;
  bool isForgotPasswordForm = false;

  @override
  void initState() {
    super.initState();
    // //CometChat SDk should be initialized at the start of application. No need to initialize it again
    // AppSettings appSettings = (AppSettingsBuilder()
    //       ..subscriptionType = CometChatSubscriptionType.allUsers
    //       ..region = CometChatAuthConstants.region
    //       ..autoEstablishSocketConnection = true)
    //     .build();

    // CometChat.init(CometChatAuthConstants.appId, appSettings,
    //     onSuccess: (String successMessage) {
    //   debugPrint("Initialization completed successfully  $successMessage");
    // }, onError: (CometChatException excep) {
    //   debugPrint("Initialization failed with exception: ${excep.message}");
    // });
    // //initialization end
  }

  @override
  Widget build(BuildContext context) {
    return Token == null &&
            isLoginForm == true &&
            isRegisterForm == false &&
            isForgotPasswordForm == false
        ? SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(top: 0),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/imgs/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: TextField(
                  controller: _phoneController,
                  autofocus: false,
                  textDirection: selectedLanguage == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  textAlign: selectedLanguage == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      prefixIcon: Icon(Icons.phone_android_outlined,
                          color: Color(0xffcccccc)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xfff39423)),
                      ),
                      border: InputBorder.none,
                      hintText: 'Mobile'.tr,
                      hintStyle: TextStyle(
                          color: Color(0xff333333),
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          fontSize: 14)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: TextField(
                  controller: _passwordController,
                  textDirection: selectedLanguage == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  textAlign: selectedLanguage == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xffcccccc),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Color(0xffcccccc)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xfff39423)),
                      ),
                      border: InputBorder.none,
                      hintText: 'Password'.tr,
                      hintStyle: TextStyle(
                          color: Color(0xff333333),
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          fontSize: 14)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isForgotPasswordForm = true;
                    isRegisterForm = false;
                    isLoginForm = false;
                  });
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    child: Align(
                        alignment: selectedLanguage == 'en'
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          'Forget Password'.tr,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          ),
                        ))),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                margin: const EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_phoneController.text == '') {
                      showErrorMessage('Please Enter Phone'.tr);
                    } else if (_phoneController.text.length < 9 ||
                        _phoneController.text.length != 9) {
                      showErrorMessage('phone length equal 9'.tr);
                    } else if (_passwordController.text == '') {
                      showErrorMessage('Please Enter Password'.tr);
                    } else if (_phoneController.text == '' &&
                        _passwordController.text == '') {
                      showErrorMessage('Please Enter Phone And Password'.tr);
                    } else if (_passwordController.text.length < 8) {
                      showErrorMessage('Password length not less than 8'.tr);
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      loginUser();
                    }
                  },
                  child: Text('Sign in'.tr,
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 16,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          fontWeight: FontWeight.w500)),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryColor)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isRegisterForm = true;
                      isLoginForm = false;
                      isForgotPasswordForm = false;
                    });
                  },
                  child: Text('New member'.tr,
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 16,
                        fontFamily:
                            selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                      )),
                  style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all<Color>(Color(0xfff4f4f4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xfff4f4f4))),
                ),
              ),
              isLoading == true
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 100, right: 100, top: 10),
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: primaryColor,
                        size: 30,
                      ),
                    )
                  : Text(''),
            ]))
        : isLoginForm == false && isRegisterForm == true
            ? RegisterScreen()
            : Token == null && isForgotPasswordForm == true
                ? ForgotPasswordScreen()
                : Text('');
  }

  Future loginUser() async {
    await storage.erase();
    Map<String, String> body = {
      "phone": _phoneController.text,
      "password": _passwordController.text,
    };
    final convertBody = json.encode(body);
    var value = await ApiServices.postApi('login',
        parameters: convertBody, headers: getHeaderNoAuth());
    var decode = json.decode(value);

    var userId = decode['user_id'];
    USERID = userId.toString();
    print(USERID);
    String authKey = CometChatAuthConstants.authKey;

    final user = await CometChat.getLoggedInUser();
    if (user == null) {
      await CometChat.login(USERID, authKey, onSuccess: (User user) {
        debugPrint("Login Successful : $user");
      }, onError: (CometChatException e) {
        debugPrint("Login failed with exception:  ${e.message}");
      });
    }

    //if login is successful
    if (user != null) {
      USERID = user.uid;
    }

    if (decode['message'] != 'Invalid login details') {
      setState(() {
        isLoading = false;
      });
      await storage.write(userToken, decode['token']);
      await storage.write(isUserLogin, true);
      // showMessage('Login Successfully'.tr);
      Get.offAll(HomeScreen());
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorMessage('The given data was invalid'.tr);
    }
  }
}

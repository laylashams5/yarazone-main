import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isShow = true;
  bool _isShowStep3 = true;
  var selectedLanguage = Get.locale?.languageCode.obs;
  void showVisible() {
    setState(() {
      _isShow = !_isShow;
    });
  }

  void showStep3() {
    setState(() {
      _isShowStep3 = !_isShowStep3;
    });
  }

  bool _passwordVisible = false;
  bool _newPasswordVisible = false;
  bool _newPasswordConfirmVisible = false;
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newConfirmPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfffbfbfb),
        appBar: AppBar(
          title: Text(
            'Change Password'.tr,
            style: TextStyle(
                color: Color(0xff333333),
                fontSize: 16,
                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
              textDirection: selectedLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              color: Color(0xff333333),
            ),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            //Setp 1
            Visibility(
                visible: _isShow,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      child: TextField(
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        textAlign: selectedLanguage == 'en'
                            ? TextAlign.left
                            : TextAlign.right,
                        obscureText: !_passwordVisible,
                        controller: _currentPasswordController,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
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
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Color(0xffcccccc)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xfff39423)),
                            ),
                            border: InputBorder.none,
                            hintText: 'Current Password'.tr,
                            hintStyle: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC',
                                fontSize: 14)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      margin: EdgeInsets.only(right: 20, left: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPasswordController.text.length < 8) {
                            showErrorMessage(
                                'Password length not less than 8'.tr);
                          } else {
                            showVisible();
                          }
                        },
                        child: Text('Next'.tr,
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 16,
                              fontFamily:
                                  selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                            )),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xfff39423))),
                      ),
                    ),
                  ],
                ),
                replacement: Visibility(
                    visible: _isShowStep3,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(
                                    1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          child: TextField(
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.right,
                            obscureText: !_newPasswordVisible,
                            controller: _newPasswordController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _newPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xffcccccc),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _newPasswordVisible =
                                          !_newPasswordVisible;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Color(0xffcccccc)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xfff39423)),
                                ),
                                border: InputBorder.none,
                                hintText: 'New Password'.tr,
                                hintStyle: TextStyle(
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC',
                                    fontSize: 14)),
                          ),
                        ),
                        SizedBox(
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
                                offset: const Offset(
                                    1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          child: TextField(
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.right,
                            obscureText: !_newPasswordConfirmVisible,
                            controller: _newConfirmPasswordController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _newPasswordConfirmVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xffcccccc),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _newPasswordConfirmVisible =
                                          !_newPasswordConfirmVisible;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Color(0xffcccccc)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xfff39423)),
                                ),
                                border: InputBorder.none,
                                hintText: 'New Confirm Password'.tr,
                                hintStyle: TextStyle(
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC',
                                    fontSize: 14)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          margin: EdgeInsets.only(right: 20, left: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_newPasswordController.text.length < 8) {
                                showErrorMessage(
                                    'Password length not less than 8'.tr);
                              } else if (_newPasswordController.text !=
                                  _newConfirmPasswordController.text) {
                                showErrorMessage(
                                    'password mis match  confirm passwrod'.tr);
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                forgotPassword();
                              }
                            },
                            child: Text('Confirm'.tr,
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 16,
                                  fontFamily: selectedLanguage == 'en'
                                      ? 'lucymar'
                                      : 'LBC',
                                )),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xfff39423))),
                          ),
                        ),
                      ],
                    ))),
            isLoading == true
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 100, right: 100, top: 20),
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: primaryColor,
                      size: 30,
                    ),
                  )
                : Text(''),
          ]),
        ),
      ),
    );
  }

  Future forgotPassword() async {
    Map<String, String> body = {
      "current_password": _currentPasswordController.text,
      "new_password": _newPasswordController.text,
      "new_confirm_password": _newConfirmPasswordController.text,
    };
    final convertBody = json.encode(body);
    var value = await ApiServices.postApi('profile/password',
        parameters: convertBody, headers: getHeaderAuth());
    var decode = json.decode(value);
    print('decode $decode');
    if (value != null) {
      setState(() {
        isLoading = false;
      });
      if (Token != null) {
        showMessage('Change Password Successfully'.tr);
        Get.to(HomeScreen());
      } else {
        showErrorMessage('The given data was invalid'.tr);
      }
      logger.e(value);
    }
  }
}

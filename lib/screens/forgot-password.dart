import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  var otp;
  // This is the entered code
  // It will be displayed in a Text widget
  String? _otp;
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
  bool _newConfirmPasswordVisible = false;
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newConfirmPasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  var verifiyOtp;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: SingleChildScrollView(
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
          SizedBox(
            height: 20,
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
                          offset:
                              const Offset(1, 1), // changes position of shadow
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    margin: EdgeInsets.only(right: 20, left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        sendOtp();
                      },
                      child: Text('Next'.tr,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          )),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFf39423))),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      isLoginForm: true,
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                        child: Row(children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff333333),
                            size: 16,
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                          ),
                          Text(
                            'Back'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.right,
                          )
                        ]),
                      ),
                    ),
                  ]),
                  isLoading == true
                      ? Container(
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.only(left: 100, right: 100, top: 10),
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: primaryColor,
                            size: 30,
                          ),
                        )
                      : Text(''),
                ],
              ),
              //Setp2
              replacement: Visibility(
                visible: _isShowStep3,
                child: Column(
                  children: [
                    // Display the entered OTP code
                    Text(
                      _otp ?? 'Enter Code'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily:
                            selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${verifiyOtp}',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      textDirection: selectedLanguage == 'en'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: selectedLanguage == 'en'
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Implement 4 input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OtpInput(_fieldOne, false),
                        OtpInput(_fieldTwo, false),
                        OtpInput(_fieldThree, false),
                        OtpInput(_fieldFour, false)
                      ],
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
                          verifitOtp();
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
                                Color(0xFFf39423))),
                      ),
                    ),

                    isLoading == true
                        ? Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 100, right: 100, top: 10),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: primaryColor,
                              size: 30,
                            ),
                          )
                        : Text(''),
                  ],
                ),
                //Step 3
                replacement: Column(
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
                        controller: _newPasswordController,
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        textAlign: selectedLanguage == 'en'
                            ? TextAlign.left
                            : TextAlign.right,
                        obscureText: !_passwordVisible,
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
                        controller: _newConfirmPasswordController,
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        textAlign: selectedLanguage == 'en'
                            ? TextAlign.left
                            : TextAlign.right,
                        obscureText: !_newConfirmPasswordVisible,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _newConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xffcccccc),
                              ),
                              onPressed: () {
                                setState(() {
                                  _newConfirmPasswordVisible =
                                      !_newConfirmPasswordVisible;
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
                          resetPassword();
                        },
                        child: Text('Confirm'.tr,
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
                    isLoading == true
                        ? Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 100, right: 100, top: 10),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: primaryColor,
                              size: 30,
                            ),
                          )
                        : Text(''),
                  ],
                ),
              )),
          // Stack(children: [
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       margin: EdgeInsets.only(top: 100),
          //       alignment: Alignment.bottomCenter,
          //       child: FloatingActionButton(
          //         hoverColor: Colors.black,
          //         elevation: 0,
          //         onPressed: () {
          //           Get.to(HomeScreen(
          //             isLoginForm: true,
          //           ));
          //         },
          //         backgroundColor: Color(0xff333333),
          //         child: Icon(
          //           Icons.login_outlined,
          //         ),
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(50.0))),
          //       ),
          //     ),
          //   )
          // ]),
        ]),
      ),
    );
  }

  Future sendOtp() async {
    isLoading = true;
    var body = {"phone": "${_phoneController.text}"};
    final convertBody = json.encode(body);
    var value = await ApiServices.postApi('send-otp',
        parameters: convertBody, headers: getHeaderNoAuth());
    var decode = json.decode(value);
    if (decode['message'] != 'otp set successfully!') {
      showErrorMessage(decode['message']);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showMessage('verify code was sent'.tr);
      await storage.write('otp', decode['otp']);
      verifiyOtp = await storage.read('otp');
      showVisible();
    }
  }

  Future verifitOtp() async {
    isLoading = true;
    otp = verifiyOtp;
    print('otp $otp');
    var body = {"phone": "${_phoneController.text}", "otp": "${otp}"};
    final convertBody = json.encode(body);
    var value = await ApiServices.postApi('confirm-otp',
        parameters: convertBody, headers: getHeaderNoAuth());
    var decode = json.decode(value);
    if (decode['message'] != 'otp validated successfully') {
      showErrorMessage(decode['message']);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showMessage('verify code is valid'.tr);
      showStep3();
    }
  }

  Future resetPassword() async {
    isLoading = true;
    otp = '${_fieldFour.text}' +
        '${_fieldThree.text}' +
        '${_fieldTwo.text}' +
        '${_fieldOne.text}';
    print(otp);
    var body = {
      "otp": "${otp}",
      "new_password": "${_newPasswordController.text}",
      "new_password_confirmation": "${_newConfirmPasswordController.text}",
      "phone": "${_phoneController.text}",
    };
    final convertBody = json.encode(body);
    print('convertBody ${convertBody}');
    var value = await ApiServices.postApi('rest-password',
        parameters: convertBody, headers: getHeaderNoAuth());
    var decode = json.decode(value);
    if (decode['message'] != 'api.password_changed_successfully') {
      setState(() {
        isLoading = false;
      });
      showErrorMessage(decode['message']);
    } else {
      setState(() {
        isLoading = false;
      });
      await storage.erase();
      showMessage('Password changed successfully'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController _verifyCodeController;
  final bool autoFocus;
  const OtpInput(this._verifyCodeController, this.autoFocus, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController _verifyCodeController = TextEditingController();
    return Container(
      width: 50,
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
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
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: _verifyCodeController,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xfff39423)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            border: InputBorder.none,
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}

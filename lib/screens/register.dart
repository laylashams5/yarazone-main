import 'dart:convert';

import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/constants.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/login.dart';

import 'package:yarazon/services/api.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  var selectedLanguage = Get.locale?.languageCode.obs;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool isLoading = false;
  String? get _errorName {
    final name = _nameController.value.text;
    if (name.isEmpty) {
      return 'Can\'t be empty'.tr;
    }
    if (name.length < 4) {
      return 'Too short'.tr;
    }
    return null;
  }

  String? get _errorEmail {
    final email = _emailController.value.text;
    if (email.isEmpty) {
      return 'Can\'t be empty'.tr;
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(email)) {
      return "Please enter valid email".tr;
    }
    return null;
  }

  String? get _errorPassword {
    final password = _passwordController.value.text;
    final confirmpassword = _passwordConfirmationController.text;
    if (password.isEmpty) {
      return 'Cant\'t be empty'.tr;
    }
    if (password != confirmpassword) {
      return 'password mis match  confirm passwrod'.tr;
    }
    if (password.length < 8) {
      return 'Too short'.tr;
    }
    return null;
  }

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
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
              controller: _nameController,
              keyboardType: TextInputType.text,
              autofocus: false,
              textDirection: selectedLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              decoration: InputDecoration(
                  errorText: _validate ? _errorName : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: Color(0xffcccccc)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xfff39423)),
                  ),
                  border: InputBorder.none,
                  hintText: 'Full Name'.tr,
                  hintStyle: TextStyle(
                      color: Color(0xff333333),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              textDirection: selectedLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              decoration: InputDecoration(
                  errorText: _validate ? _errorEmail : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  prefixIcon:
                      Icon(Icons.email_outlined, color: Color(0xffcccccc)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xfff39423)),
                  ),
                  border: InputBorder.none,
                  hintText: 'Email'.tr,
                  hintStyle: TextStyle(
                      color: Color(0xff333333),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
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
              controller: _phoneController,
              keyboardType: TextInputType.number,
              autofocus: false,
              textDirection: selectedLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  prefixIcon: Icon(Icons.phone_android_outlined,
                      color: Color(0xffcccccc)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xfff39423)),
                  ),
                  border: InputBorder.none,
                  hintText: 'Mobile'.tr,
                  hintStyle: TextStyle(
                      color: Color(0xff333333),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
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
              keyboardType: TextInputType.visiblePassword,
              textDirection: selectedLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                  errorText: _validate ? _errorPassword : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
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
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Color(0xffcccccc)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xfff39423)),
                  ),
                  border: InputBorder.none,
                  hintText: 'Password'.tr,
                  hintStyle: TextStyle(
                      color: Color(0xff333333),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
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
              controller: _passwordConfirmationController,
              keyboardType: TextInputType.visiblePassword,
              textDirection: selectedLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              obscureText: !_confirmPasswordVisible,
              decoration: InputDecoration(
                  errorText: _validate ? _errorPassword : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xffcccccc),
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Color(0xffcccccc)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xfff39423)),
                  ),
                  border: InputBorder.none,
                  hintText: 'Confirm Password'.tr,
                  hintStyle: TextStyle(
                      color: Color(0xff333333),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                      fontSize: 14)),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: const EdgeInsets.only(right: 20, left: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text == '') {
                  showErrorMessage('Please Enter Name'.tr);
                } else if (_emailController.text.isNotEmpty) {
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(_emailController.text)) {
                    showErrorMessage("Please enter valid email".tr);
                  }
                } else if (_phoneController.text == '') {
                  showErrorMessage('Please Enter Phone'.tr);
                } else if (_phoneController.text.length < 9 ||
                    _phoneController.text.length != 9) {
                  showErrorMessage('phone length equal 9'.tr);
                } else if (_passwordController.text == '' ||
                    num.tryParse(_phoneController.text) == null) {
                  showErrorMessage('Please Enter Password'.tr);
                } else if (_phoneController.text == '' &&
                    _passwordController.text == '') {
                  showErrorMessage('Please Enter Phone And Password'.tr);
                } else if (_phoneController.text == '') {
                  showErrorMessage('Please Enter Phone'.tr);
                } else if (_passwordController.text.length < 8) {
                  showErrorMessage('Password length not less than 8'.tr);
                } else if (_passwordController.text !=
                    _passwordConfirmationController.text) {
                  showErrorMessage('password mis match  confirm passwrod'.tr);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  registerUser();
                }
              },
              child: Text('Sign Up'.tr,
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 16,
                      fontFamily:
                          selectedLanguage == 'en' ? 'lucymar' : 'LBC')),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xfff39423))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Do You Hava Account'.tr,
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff333333),
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
              ),
              Padding(padding: const EdgeInsets.only(left: 3)),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  isLoginForm: true,
                                )));
                  },
                  child: Text(
                    'Sign in'.tr,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily:
                            selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                        color: Color(0xfff39423)),
                  )),
            ],
          ),
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
        ],
      ),
    );
  }

  Future registerUser() async {
    print('registerUser');
    await storage.erase();
    Map<String, String> body = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "password": _passwordController.text,
      "password_confirmation": _passwordConfirmationController.text
    };
    isLoading = true;
    final convertBody = json.encode(body);
    var value = await ApiServices.postApi('register',
        parameters: convertBody, headers: getHeaderAuth());
    var decode = json.decode(value);

    if (decode['message'] == "تم إنشاء حسابك بنجاح.") {
      setState(() {
        isLoading = false;
      });
      // await storage.write(userToken, decode['token']);
      // await storage.write(isUserLogin, true);
      // await storage.write(completeUser, decode);
      // showMessage('Register Successfully'.tr);
      var userId = decode['user_id'];
      String authKey = CometChatAuthConstants.authKey;
      String UserID = userId.toString();
      print(decode);
      setState(() {
        USERID = UserID;
      });
      User user = User(
        uid: UserID,
        name: _nameController.text,
      );
      CometChat.createUser(user, authKey, onSuccess: (User user) async {
        debugPrint("Create User succesful ${user}");
      }, onError: (CometChatException e) {
        debugPrint("Create User Failed with exception ${e.message}");
      });
      // Get.offAll(LoginScreen());

      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  isLoginForm: true,
                                )));

    } else {
      setState(() {
        isLoading = false;
      });
      print(decode);
      if (decode['errors'].containsKey('phone') == true &&
          decode['errors'].containsKey('email') == true) {
        showErrorMessage(
            decode['errors']['phone'][0] + ' ' + decode['errors']['email'][0]);
      }
      if (decode['errors'].containsKey('email') == true &&
          decode['errors'].containsKey('phone') == false) {
        showErrorMessage(decode['errors']['email'][0]);
      }
      if (decode['errors'].containsKey('phone') == true &&
          decode['errors'].containsKey('email') == false) {
        showErrorMessage(decode['errors']['phone'][0]);
      }
    }
  }
}

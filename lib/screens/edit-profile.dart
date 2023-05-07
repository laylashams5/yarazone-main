import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/helper.dart';
import 'dart:io';

import 'package:yarazon/services/api.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var userData;
  var selectedLanguage = Get.locale?.languageCode.obs;
  late File _image;
  bool isLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xfffbfbfb),
        appBar: AppBar(
          title: Text(
            'Profile'.tr,
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
          Center(
            child: GestureDetector(
                onTap: () async {
                  // var image =
                  //     await ImagePicker().getImage(source: ImageSource.gallery);

                  // if (image == null) return;

                  // if (!mounted) return;
                  // setState(() {
                  //   _image = File(image.path);
                  // });
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: imagUrl,
                          width: 100,
                          height: 100,
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
                    ),
                    // Positioned(
                    //   left: 0,
                    //   right: 0,
                    //   top: 60,
                    //   child: Align(
                    //       alignment: Alignment.bottomCenter,
                    //       child: Icon(Icons.camera_alt_outlined,
                    //           color: Colors.white, size: 35)),
                    // )
                  ],
                )),
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
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.only(right: 20, left: 20),
            child: TextField(
              controller: _nameController,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                prefixIcon: Icon(Icons.person_outline_outlined,
                    color: Color(0xffcccccc)),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: primaryColor),
                ),
              ),
              keyboardType: TextInputType.name,
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
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.only(right: 20, left: 20),
            child: TextField(
              controller: _emailController,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                prefixIcon:
                    Icon(Icons.email_outlined, color: Color(0xffcccccc)),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
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
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.only(right: 20, left: 20),
            child: TextField(
              controller: _phoneController,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                prefixIcon:
                    Icon(Icons.phone_outlined, color: Color(0xffcccccc)),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: EdgeInsets.only(right: 20, left: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text == '') {
                  showErrorMessage('Please Enter Name'.tr);
                } else if (_phoneController.text == '' ||
                    num.tryParse(_phoneController.text) == null) {
                  showErrorMessage('Please Enter Phone'.tr);
                } else if (_phoneController.text.length != 9) {
                  showErrorMessage('phone length equal 9'.tr);
                } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(_emailController.text)) {
                  showErrorMessage("Please enter valid email".tr);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  updateProfile();
                }
              },
              child: Text('Update Profile'.tr,
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 16,
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
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
          isLoading == true
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 100, right: 100, top: 100),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: primaryColor,
                    size: 30,
                  ),
                )
              : Text(''),
        ])),
      ),
    );
  }

  Future getUserInfo() async {
    isLoading = true;
    var value = await ApiServices.getApi('me', headers: getHeaderAuth());
    if (Token != null) {
      setState(() {
        isLoading = false;
      });
      value = json.decode(value);
      value = value['data'];
      userData = value;
      _nameController.text = userData['name'];
      if (userData['email'] != null) {
        _emailController.text = userData['email'];
      }
      _phoneController.text = userData['phone'];
      // print('res ${userData.toJson()}');
    }
  }

  Future updateProfile() async {
    isLoading = true;
    Map<String, String> body = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
    };
    final convertBody = json.encode(body);
    var value = await ApiServices.postApi('profile/update',
        parameters: convertBody, headers: getHeaderAuth());
    var decode = json.decode(value);
    if (value != null) {
      setState(() {
        isLoading = false;
      });
      if (Token != null) {
        showMessage('Updated Successfully'.tr);
      }
    } else {
      showErrorMessage('The given data was invalid'.tr);
    }
    logger.e(value);
  }
}

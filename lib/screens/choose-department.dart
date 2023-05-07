import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/models/chat.dart';
import 'package:yarazon/models/department.dart';
import 'package:yarazon/screens/chat.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';

class ChooseDepartmentScreen extends StatefulWidget {
  ChooseDepartmentScreen({Key? key}) : super(key: key);

  @override
  State<ChooseDepartmentScreen> createState() => _ChooseDepartmentScreenState();
}

class _ChooseDepartmentScreenState extends State<ChooseDepartmentScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  List<Department> departments = [
    Department(id: 1, name_ar: 'عام', name_en: 'General'),
    Department(id: 2, name_ar: 'طلب جديد', name_en: 'New Order'),
    Department(id: 3, name_ar: 'شكوى', name_en: 'Complain')
  ];

  var userData;
  bool isLoading = false;
  int? dept;
  @override
  void initState() {
    super.initState();
    getUserInfo();
    showChats();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(children: [
        Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/imgs/logo.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'welcome to yarazon choose department'.tr,
            style: TextStyle(
                color: Color(0xff333333),
                fontSize: 16,
                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.only(right: 5, left: 10),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              focusColor: primaryColor,
              items: departments.map((Department department) {
                return DropdownMenuItem(
                  value: department.id,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        selectedLanguage == 'en'
                            ? department.name_en
                            : department.name_ar,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff333333),
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                        textDirection: selectedLanguage == 'en'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        textAlign: selectedLanguage == 'en'
                            ? TextAlign.left
                            : TextAlign.right,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  dept = value!;
                });
              },
              value: dept,
              hint: Text(
                "Choose Dept".tr,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff333333),
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                textDirection: selectedLanguage == 'en'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlign:
                    selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              ),
              elevation: 8,
              style: TextStyle(color: Color(0xff333333), fontSize: 14),
              icon: Icon(
                Icons.contact_mail_outlined,
                color: Color(0xff333333),
              ),
              iconDisabledColor: Color(0xfff4f4f4),
              iconEnabledColor: Color(0xff333333),
              isExpanded: true,
              dropdownColor: Color(0xfff4f4f4),
              alignment: Alignment.center,
            ),
          ),
        ),
        SizedBox(
          height: 20,
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
              // createChat();
              print(dept);
              if (dept == null) {
                showErrorMessage('The given data was invalid'.tr);
              } else {
                print('Go here waaaaay');
                Get.to(Scaffold(
                    resizeToAvoidBottomInset: true,
                    backgroundColor: Color(0xfffbfbfb),
                    appBar: AppBar(
                      backgroundColor: Color(0xfff4f4f4),
                      elevation: 0,
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () {
                            Get.to(HomeScreen());
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff333333),
                            size: 18,
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                          )),
                      title: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: imagUrl,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, color: primaryColor),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    value: downloadProgress.progress,
                                  ),
                                ),
                                width: 60,
                                height: 60,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              userData?['name'] != null
                                  ? '${userData?['name']}'
                                  : '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff333333),
                                  fontFamily: selectedLanguage == 'en'
                                      ? 'lucymar'
                                      : 'LBC'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ])),
                      toolbarHeight: 120,
                    ),
                    body: ChatScreen(
                      messageList: oldMessages,
                    )));
              }
            },
            child: Text('Chat'.tr,
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
      ]),
    );
  }

  Future showChats() async {
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('chat/start', headers: headers);
    value = json.decode(value);
    value.forEach((item) {
      var content = item as List<dynamic>;
      oldMessages = content
          .map((model) => Chat.fromJson(model as Map<String, dynamic>))
          .toList();
    });

    print('oldMessages depart ${oldMessages.length}');
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

  Future createChat() async {
    isLoading = true;
    Map<String, String> body = {
      "message": 'yarazonbot-${dept}',
      "attachmetns": '',
    };
    final convertBody = json.encode(body);
    if (dept != null) {
      await ApiServices.postApi('chat/send-message',
          parameters: convertBody, headers: getHeaderAuth());
      setState(() {
        isLoading = false;
      });
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/models/contact-info.dart';
import 'package:yarazon/models/contact-links.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class ContactUsScreen extends StatefulWidget {
  ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool isLoading = false;
 late ContactInfo contactInfo;
 late ContactLinks contactLinks;
@override
  void initState() {
    super.initState();
    getContactInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffbfbfb),
        appBar: AppBar(
          title: Text(
            'Contact US'.tr,
            style: TextStyle(
                color: Color(0xff333333),
                fontSize: 16,
                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
          ),
          leading: IconButton(
            onPressed: () {
              Get.to(HomeScreen());
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
        body: isLoading == false? SingleChildScrollView(
            physics: ScrollPhysics(), child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Container(
                margin: const EdgeInsets.only(top: 0),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/imgs/logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children :[Column(children: [
              Text("Address".tr,
            style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                            fontWeight: FontWeight.w500),),
              SizedBox(height: 20,),
              Text("Email".tr,
            style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                            fontWeight: FontWeight.w500),),
                            SizedBox(height: 20,),
              Text("Mobile".tr,
            style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                            fontWeight: FontWeight.w500),)],),
                            SizedBox(width: 10,),
                            Container(height: 90,width: 1,color: Colors.grey,),
                            SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: 
                    [Text(contactInfo.address,
            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 16,
                              fontFamily:
                                  selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                              fontWeight: FontWeight.w500),),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () async{
    final Uri params = Uri(
  scheme: 'mailto',
  path: contactInfo.email,
);
var url = params.toString();
    if (await canLaunch(url)) {
  await launch(url);
} else {
  throw 'Could not launch $url';
}
  },
                      child: Text(contactInfo.email,
                                style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontFamily:
                                    selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                                fontWeight: FontWeight.w500),),
                    ),
                              SizedBox(height: 20,),
                    GestureDetector(
                       onTap: (){
                        var phone = contactInfo.phone;
                        launch("tel://$phone");
                       },
                      child: Text(contactInfo.phone,
                                style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontFamily:
                                    selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                                fontWeight: FontWeight.w500),),
                    )],),
                  )]),
                ),
                SizedBox(height: 20,),
                Text('Find us on social media :'.tr,style :TextStyle(
                              color: Color(0xff333333),
                              fontSize: 16,
                              fontFamily:
                                  selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                              fontWeight: FontWeight.w500)),
                          Row(children: [
                            IconButton(icon: Icon(FontAwesomeIcons.facebook, size: 16.0),onPressed: () async{
    var url = contactLinks.facebook;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                            IconButton(icon: Icon(FontAwesomeIcons.twitter, size: 16.0),onPressed: ()async{
    var url = contactLinks.twitter;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                            IconButton(icon: Icon(FontAwesomeIcons.instagram, size: 16.0),onPressed: ()async{
    var url = contactLinks.instagram;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                            IconButton(icon: Icon(FontAwesomeIcons.linkedin, size: 16.0),onPressed: ()async{
    var url = contactLinks.linkedin;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                            IconButton(icon: Icon(FontAwesomeIcons.youtube, size: 16.0),onPressed: ()async{
    var url = contactLinks.youtube;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                            IconButton(icon: Icon(FontAwesomeIcons.tiktok, size: 16.0),onPressed: ()async{
    var url = contactLinks.tiktok;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                            IconButton(icon: Icon(FontAwesomeIcons.whatsapp, size: 16.0),onPressed: ()async{
    var url = contactLinks.whatsapp;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                            IconButton(icon: Icon(FontAwesomeIcons.telegram, size: 16.0),onPressed: ()async{
    var url = contactLinks.telegram;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  },),
                          ],)]))):Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: primaryColor,
                          size: 30,
                        ),
                      ));
  }
  Future getContactInfo() async {
    isLoading = true;
    var headers = getHeaderNoAuth();
    var value = await ApiServices.getApi('contact-info', headers: headers);
      setState(() {
        isLoading = false;
      });
      value = json.decode(value);
      print(value['data']['info']);
    contactInfo =  ContactInfo.fromJson(value['data']['info']);
      print(value['data']['links']);
    contactLinks =  ContactLinks.fromJson(value['data']['links']);
    }
}

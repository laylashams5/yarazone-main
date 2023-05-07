import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/services/api.dart';

class Brands extends StatefulWidget {
  Brands({Key? key}) : super(key: key);

  @override
  State<Brands> createState() => BrandsState();
}

class BrandsState extends State<Brands> {
  bool isLoading = false;
  List brands = [];
  @override
  void initState() {
    super.initState();
    getBrands();
  }

  @override
  Widget build(BuildContext context) {
    var selectedLanguage = Get.locale?.languageCode.obs;
    return isLoading == true
        ? Container(
            width: double.infinity,
            child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: 50, minWidth: double.infinity),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Text(''),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xfff4f4f4)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey.withOpacity(0.2)),
                      );
                    })))
        : brands.length != 0
            ? Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Brands'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          color: Color(0xff666666),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 50, minWidth: double.infinity),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        double leftMargin = 8;
                        double rightMargin = 8;
                        if (index == 0) {
                          leftMargin = 12;
                        }
                        if (index == brands.length - 1) {
                          rightMargin = 12;
                        }
                        return GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: Row(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 3, right: 3)),
                                  if (brands[index]['name'] != null)
                                    Text(brands[index]['name'],
                                        style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: selectedLanguage == 'en'
                                                ? 'lucymar'
                                                : 'LBC'),
                                        textDirection: selectedLanguage == 'en'
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        textAlign: selectedLanguage == 'en'
                                            ? TextAlign.left
                                            : TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                ],
                              ),
                              margin: EdgeInsets.only(left: leftMargin),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Color(0xfff4f4f4)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                            ));
                      },
                      primary: false,
                      itemCount: brands.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                )
              ])
            : Container();
  }

  Future getBrands() async {
    isLoading = true;
    var headers = getHeaderNoAuth();
    var value = await ApiServices.getApi('brands?', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    brands = value;
  }
}

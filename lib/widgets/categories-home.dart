import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/models/category.dart';
import 'package:yarazon/screens/categories.dart';
import 'package:yarazon/services/api.dart';
import 'package:yarazon/widgets/product-categories.dart';

class CategoriesHome extends StatefulWidget {
  CategoriesHome({Key? key}) : super(key: key);

  @override
  State<CategoriesHome> createState() => _CategoriesHomeState();
}

class _CategoriesHomeState extends State<CategoriesHome> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  List<Category> categories = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
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
        : categories.length != 0
            ? Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily:
                            selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                        color: Color(0xff666666),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(CategoriesScreen());
                      },
                      child: Text(
                        'See All'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          color: Color(0xfff39423),
                        ),
                      ),
                    )
                  ],
                ),
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
                        if (index == categories.length - 1) {
                          rightMargin = 12;
                        }
                        return GestureDetector(
                            onTap: () {
                              Get.to(ProductsCategories(
                                  products: categories[index].products));
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.grid_view_outlined,
                                    size: 18,
                                    color: Color(0xff666666),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 3, right: 3)),
                                  if (categories[index].name != '')
                                    Text(categories[index].name,
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
                                  color: Color(0xfff4f4f4)),
                            ));
                      },
                      primary: false,
                      itemCount: categories.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                )
              ])
            : Container();
  }

  Future getCategories() async {
    isLoading = true;
    var headers = getHeaderNoAuth();
    var value =
        await ApiServices.getApi('categories?featured', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    var content = value as List<dynamic>;
    categories = content
        .map((model) => Category.fromJson(model as Map<String, dynamic>))
        .toList();
  }
}

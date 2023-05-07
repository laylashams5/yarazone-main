import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';
import 'package:yarazon/widgets/product-categories.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  double minPrice = 0.0;
  double maxPrice = 0.0;
  RangeValues _currentRangeValues = new RangeValues(0.0, 0.0);
  List colors = [];
  bool selectedCategory = false;
  bool selectedBrand = false;
  bool selectedColor = false;
  bool selectedSize = false;
  List sizes = [];
  List categories = [];
  List brands = [];
  bool isLoading = false;
  List products = [];
  List filterProducts = [];
  int? categoryId;
  int? brandId;
  int? colorId;
  int? sizeId;
  @override
  void initState() {
    super.initState();
    getProducts();
    getCategories();
    getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xfffbfbfb),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Filter'.tr,
            style: TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xff333333),
                size: 18,
                textDirection: selectedLanguage == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
              )),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 22,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                child: Icon(
                  Icons.clear,
                  size: 18,
                  color: Color(0xff3333333),
                ),
              ),
            ),
          ],
        ),
        body: isLoading == true
            ? Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: primaryColor,
                  size: 30,
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.80,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Prices
                          Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 10, left: 10, right: 10),
                              child: Text(
                                'Price range'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                                textDirection: selectedLanguage == 'en'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                textAlign: selectedLanguage == 'en'
                                    ? TextAlign.left
                                    : TextAlign.right,
                              )),
                          Container(
                              decoration: BoxDecoration(
                                  color: Color(0xfff4f4f4),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_currentRangeValues.start}' +
                                            ' ' +
                                            'SDG'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color(0xff333333),
                                            fontFamily: selectedLanguage == 'en'
                                                ? 'lucymar'
                                                : 'LBC'),
                                        textDirection: selectedLanguage == 'en'
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        textAlign: selectedLanguage == 'en'
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                      Text(
                                        '${_currentRangeValues.end}' +
                                            ' ' +
                                            'SDG'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color(0xff333333),
                                            fontFamily: selectedLanguage == 'en'
                                                ? 'lucymar'
                                                : 'LBC'),
                                        textDirection: selectedLanguage == 'en'
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        textAlign: selectedLanguage == 'en'
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                    ],
                                  ),
                                  RangeSlider(
                                    activeColor: primaryColor,
                                    inactiveColor: Colors.grey,
                                    values: _currentRangeValues,
                                    max: maxPrice,
                                    min: minPrice,
                                    divisions: 5,
                                    labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeValues = values;
                                      });
                                    },
                                  )
                                ],
                              )),
                          //Colors
                          Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 10, left: 10, right: 10),
                              child: Text(
                                'Colors'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                                textDirection: selectedLanguage == 'en'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                textAlign: selectedLanguage == 'en'
                                    ? TextAlign.left
                                    : TextAlign.right,
                              )),
                          Container(
                              decoration: BoxDecoration(
                                  color: Color(0xfff4f4f4),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Column(children: [
                                if (colors.length == 0)
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      'There No Colors'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: selectedLanguage == 'en'
                                            ? 'lucymar'
                                            : 'LBC',
                                      ),
                                    ),
                                  ),
                                if (colors.length != 0)
                                  Container(
                                    width: double.infinity,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 50,
                                          minWidth: double.infinity),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          double leftMargin = 8;
                                          double rightMargin = 8;
                                          if (index == 0) {
                                            leftMargin = 12;
                                          }
                                          if (index == colors.length - 1) {
                                            rightMargin = 12;
                                          }
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedColor =
                                                      !selectedColor;
                                                  if (selectedColor == true) {
                                                    colorId =
                                                        colors[index]['id'];
                                                  } else {
                                                    colorId;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  height: 50.0,
                                                  width: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: colors[
                                                        index], //this is the important line
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),

                                                    border: Border.all(
                                                        color: selectedColor ==
                                                                    true &&
                                                                colors[index][
                                                                        'id'] ==
                                                                    colorId
                                                            ? Color(0xff333333)
                                                            : Colors
                                                                .transparent,
                                                        width: 3),
                                                  )));
                                        },
                                        primary: false,
                                        itemCount: colors.length,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ),
                              ])),

                          //Sizes
                          Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 10, left: 10, right: 10),
                              child: Text(
                                'Sizes'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                                textDirection: selectedLanguage == 'en'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                textAlign: selectedLanguage == 'en'
                                    ? TextAlign.left
                                    : TextAlign.right,
                              )),
                          Container(
                              decoration: BoxDecoration(
                                  color: Color(0xfff4f4f4),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Column(children: [
                                if (sizes.length == 0)
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      'There No Sizes'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: selectedLanguage == 'en'
                                            ? 'lucymar'
                                            : 'LBC',
                                      ),
                                    ),
                                  ),
                                if (sizes.length != 0)
                                  Container(
                                    width: double.infinity,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 50,
                                          minWidth: double.infinity),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          double leftMargin = 8;
                                          double rightMargin = 8;
                                          if (index == 0) {
                                            leftMargin = 12;
                                          }
                                          if (index == sizes.length - 1) {
                                            rightMargin = 12;
                                          }
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedSize = !selectedSize;
                                                  if (selectedSize == true) {
                                                    sizeId= sizes[index]['id'];
                                                  } else {
                                                    sizeId;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                child: Text(
                                                  sizes[index]['name'],
                                                  style: TextStyle(
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? 'lucymar'
                                                              : 'LBC'),
                                                  textDirection:
                                                      selectedLanguage == 'en'
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                  textAlign:
                                                      selectedLanguage == 'en'
                                                          ? TextAlign.left
                                                          : TextAlign.right,
                                                ),
                                                margin: EdgeInsets.only(
                                                    left: leftMargin),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color: selectedSize ==
                                                                    true &&
                                                                sizes[index][
                                                                        'id'] ==
                                                                    sizeId
                                                            ? Color(0xff333333)
                                                            : Color(0xffeeeeee),
                                                        width: 2),
                                                    color: Color(0xfffafafa)),
                                              ));
                                        },
                                        primary: false,
                                        itemCount: sizes.length,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ),
                              ])),

                          // Categories
                          Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 10, left: 10, right: 10),
                              child: Text(
                                'Categories'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                                textDirection: selectedLanguage == 'en'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                textAlign: selectedLanguage == 'en'
                                    ? TextAlign.left
                                    : TextAlign.right,
                              )),
                          Container(
                              decoration: BoxDecoration(
                                  color: Color(0xfff4f4f4),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Column(children: [
                                if (categories.length == 0)
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      'There No Categories'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: selectedLanguage == 'en'
                                            ? 'lucymar'
                                            : 'LBC',
                                      ),
                                    ),
                                  ),
                                if (categories.length != 0)
                                  Container(
                                    width: double.infinity,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 50,
                                          minWidth: double.infinity),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          double leftMargin = 8;
                                          double rightMargin = 8;
                                          if (index == 0) {
                                            leftMargin = 12;
                                          }
                                          if (index == sizes.length - 1) {
                                            rightMargin = 12;
                                          }
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory =
                                                      !selectedCategory;
                                                  if (selectedCategory ==
                                                      true) {
                                                    categoryId =
                                                        categories[index]['id'];
                                                  } else {
                                                    categoryId;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                child: Text(
                                                  categories[index]['name'],
                                                  style: TextStyle(
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? 'lucymar'
                                                              : 'LBC'),
                                                  textDirection:
                                                      selectedLanguage == 'en'
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                  textAlign:
                                                      selectedLanguage == 'en'
                                                          ? TextAlign.left
                                                          : TextAlign.right,
                                                ),
                                                margin: EdgeInsets.only(
                                                    left: leftMargin),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color: selectedCategory ==
                                                                    true &&
                                                                categories[index]
                                                                        [
                                                                        'id'] ==
                                                                    categoryId
                                                            ? Color(0xff333333)
                                                            : Color(0xffeeeeee),
                                                        width: 2),
                                                    color: Color(0xfffafafa)),
                                              ));
                                        },
                                        primary: false,
                                        itemCount: categories.length,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ),
                              ])),

                          // Brands
                          Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 10, left: 10, right: 10),
                              child: Text(
                                'Brands'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                                textDirection: selectedLanguage == 'en'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                textAlign: selectedLanguage == 'en'
                                    ? TextAlign.left
                                    : TextAlign.right,
                              )),
                          Container(
                              decoration: BoxDecoration(
                                  color: Color(0xfff4f4f4),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Column(children: [
                                if (brands.length == 0)
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      'There No Brands'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: selectedLanguage == 'en'
                                            ? 'lucymar'
                                            : 'LBC',
                                      ),
                                    ),
                                  ),
                                if (brands.length != 0)
                                  Container(
                                    width: double.infinity,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 50,
                                          minWidth: double.infinity),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          double leftMargin = 8;
                                          double rightMargin = 8;
                                          if (index == 0) {
                                            leftMargin = 12;
                                          }
                                          if (index == sizes.length - 1) {
                                            rightMargin = 12;
                                          }
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedBrand =
                                                      !selectedBrand;
                                                  if (selectedBrand == true) {
                                                    brandId =
                                                        brands[index]['id'];
                                                  } else {
                                                    brandId;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                child: Text(
                                                  brands[index]['name'],
                                                  style: TextStyle(
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? 'lucymar'
                                                              : 'LBC'),
                                                  textDirection:
                                                      selectedLanguage == 'en'
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                  textAlign:
                                                      selectedLanguage == 'en'
                                                          ? TextAlign.left
                                                          : TextAlign.right,
                                                ),
                                                margin: EdgeInsets.only(
                                                    left: leftMargin),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color: selectedBrand ==
                                                                    true &&
                                                                brands[index][
                                                                        'id'] ==
                                                                    brandId
                                                            ? Color(0xff666666)
                                                            : Color(0xffeeeeee),
                                                        width: 2),
                                                    color: Color(0xfffafafa)),
                                              ));
                                        },
                                        primary: false,
                                        itemCount: brands.length,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ),
                              ])),

                          isLoading == true
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 100, right: 100, top: 100),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                )
                              : Text(''),
                        ])),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //apply
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 36,
              margin: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  getFilterProducts();
                },
                child: Text('Filter'.tr,
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 14,
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
            //discard
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 36,
              margin: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xfff4f4f4), width: 1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Discard'.tr,
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 14,
                        fontFamily:
                            selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                        fontWeight: FontWeight.w500)),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future getFilterProducts() async {
    print('_currentRangeValues.start ${_currentRangeValues.start}');
    print('_currentRangeValues.end ${_currentRangeValues.end}');
    print('colorId $colorId $selectedColor');
    print('sizeId $sizeId $selectedSize');
    print('categoryId $categoryId $selectedCategory ');
    print('brandId $brandId $selectedBrand');
    isLoading = true;
    var value;
    var headers = getHeaderNoAuth();
    if (_currentRangeValues.start != 0.0 || _currentRangeValues.end != 0.0) {
      value = await ApiServices.getApi(
          'products?filter[price_sdg]=${_currentRangeValues.start},${_currentRangeValues.end}',
          headers: headers);
    }
    if (colorId != null && selectedColor == true) {
      value = await ApiServices.getApi(
          'products?filter[name]=&filter[color.id]=${colorId}',
          headers: headers);
    }
    if (sizeId != null && selectedSize == true) {
      value = await ApiServices.getApi(
          'products?filter[name]=&filter[size.id]=${sizeId}',
          headers: headers);
    }
    if (categoryId != null && selectedCategory == true) {
      value = await ApiServices.getApi(
          'products?filter[name]=&filter[category.id]=${categoryId}',
          headers: headers);
    }
    if (brandId != null && selectedBrand == true) {
      value = await ApiServices.getApi(
          'products?filter[name]=&filter[brand.id]=${brandId}',
          headers: headers);
    }
    if (categoryId != null &&
        brandId != null &&
        selectedBrand == true &&
        selectedCategory == true) {
      value = await ApiServices.getApi(
          'products?filter[name]=&filter[category.id]=${categoryId}&filter[price_sdg]=${_currentRangeValues.start},${_currentRangeValues.end}&filter[brand.id]=${brandId}&filter[color.id]=${colorId}&filter[size.id]=${sizeId}',
          headers: headers);
    }
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    filterProducts = value;
    print('filterProducts $filterProducts');
    Get.to(ProductsCategories(
      products: filterProducts,
      pageName: 'search',
    ));
  }

  Future getProducts() async {
    var headers = Token == null ? getHeaderNoAuth() : getHeaderAuth();
    var res = await ApiServices.getApi('products', headers: headers);
    res = json.decode(res);
    res = res['data'];
    products = res;
    if (products.length != 0) {
      setState(() {
        products.sort((a, b) => a["price_sdg"].compareTo(b["price_sdg"]));
        maxPrice = double.parse(products.last['price_sdg'].replaceAll(',', ''));
        products.sort((a, b) => b["price_sdg"].compareTo(a["price_sdg"]));
        minPrice = double.parse(products.last['price_sdg'].replaceAll(',', ''));
        _currentRangeValues = RangeValues(minPrice, maxPrice);
      });
    }
  }

  Future getColor() async {
    isLoading = true;
    var headers = getHeaderNoAuth();
    var value = await ApiServices.getApi('colors', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    colors = value;
    print('colors ${colors.length}');
  }

  Future getSizes() async {
    isLoading = true;
    var headers = getHeaderNoAuth();
    var value = await ApiServices.getApi('sizes', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    sizes = value;
    print('sizes ${sizes.length}');
  }

  Future getCategories() async {
    isLoading = true;
    var headers = getHeaderNoAuth();
    var value = await ApiServices.getApi('categories', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    categories = value;
    print('categories ${categories.length}');
  }

  Future getBrands() async {
    isLoading = true;
    var headers = getHeaderNoAuth();
    var value = await ApiServices.getApi('brands', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    brands = value;
    print('brands ${brands.length}');
  }
}

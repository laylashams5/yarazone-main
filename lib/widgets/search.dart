import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';
import 'dart:ui' as ui;

import 'package:yarazon/widgets/product-categories.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  List productList = [];
  bool searchLoader = false;
  bool isLoading = false;
  final TextEditingController _searchKeyword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Color(0xfff4f4f4))),
      child: TextField(
        textInputAction:TextInputAction.search,
        onSubmitted: (value) {
          searchWithKeyword();
        },
        autofocus: false,
        controller: _searchKeyword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xfff4f4f4),
          hintText: "Search".tr,
          hintStyle: TextStyle(
              color: Color(0xff333333),
              fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC',
              fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 2, color: Color(0xfff4f4f4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          suffixIcon: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16 / 2),
            child: SizedBox(
              width: 55,
              height: 48,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: () {
                    searchWithKeyword();
                  },
                  child: Icon(
                    Icons.search_outlined,
                    color: Color(0xff333333),
                    size: 25,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Future toggleFavLastest(var productId) async {
    if (Token != null) {
      searchLoader = true;
      var body = {};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('wishes/$productId/toggle',
          parameters: convertBody, headers: getHeaderAuth());
      var decode = json.decode(value);
      if (decode != "Removed") {
        showMessage('Added item to fav!'.tr);
      } else {
        showMessage('removed item to fav!'.tr);
      }
      setState(() {
        productList;
      });
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future addToCart(var productId) async {
    if (Token != null) {
      var body = {"product_id": "$productId", "qty": 1};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('cart/add',
          parameters: convertBody, headers: getHeaderAuth());
      showMessage('Added item to cart!'.tr);
      setState(() {
        productList;
      });
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future removeFromCart(var productId) async {
    showMessage("You can't add product twice".tr);
  }

  Future searchWithKeyword() async {
    searchLoader = true;
    if (_searchKeyword.text != '') {
      var headers = getHeaderAuth();
      var value = await ApiServices.getApi(
          'product-search?keyword=${_searchKeyword.text}',
          headers: headers);
      setState(() {
        searchLoader = false;
      });
      value = json.decode(value);
      value = value['data'];
      productList = value;
      print('productList funct ${productList.length}');
      Get.to(ProductsCategories(
        products: productList,
        pageName: 'search',
        searchKeyword: _searchKeyword.text,
      ));
    } else {
      showErrorMessage('The given data was invalid'.tr);
    }
  }
}

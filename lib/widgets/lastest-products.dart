import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/product-detials.dart';
import 'package:yarazon/services/api.dart';

class LastetProducts extends StatefulWidget {
  LastetProducts({Key? key}) : super(key: key);

  @override
  State<LastetProducts> createState() => _LastetProductsState();
}

class _LastetProductsState extends State<LastetProducts> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  List latestProducts = [];
  bool lastProductLoader = false;
  @override
  void initState() {
    super.initState();
    Token = storage.read('userToken');
    getLatestProducts();
  }

  @override
  Widget build(BuildContext context) {
    return

        //Latest Products
        lastProductLoader == true
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 160,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      String? image;
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xfff4f4f4),
                                  blurRadius: 10,
                                  spreadRadius: 5),
                            ],
                          ),
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, bottom: 8, top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {},
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Skelton(
                                                      width: 100, height: 200)),
                                            ])),
                                  ],
                                ),
                                Divider(
                                  color: Color(
                                    0xfff4f4f4,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5, top: 5),
                                  child: Skelton(width: 100, height: 20),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Skelton(width: 100, height: 20),
                                  ],
                                )
                              ],
                            ),
                          ));
                    }),
              )
            : latestProducts.length != 0
                ? Column(children: [
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Latest products'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xff555555),
                              fontFamily:
                                  selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                          textDirection: selectedLanguage == 'en'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          textAlign: selectedLanguage == 'en'
                              ? TextAlign.left
                              : TextAlign.right,
                          softWrap: true,
                        )
                      ],
                    )),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).orientation == Orientation.portrait? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * 0.9,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisExtent: 180,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          padding: EdgeInsets.only(left: 5, right: 5),
                          scrollDirection: Axis.horizontal,
                          itemCount: latestProducts.length,
                          itemBuilder: (BuildContext context, index) {
                            String? image;
                            return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xfff4f4f4),
                                        blurRadius: 10,
                                        spreadRadius: 5),
                                  ],
                                ),
                                margin: EdgeInsets.only(top: 15, bottom: 15),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, bottom: 8, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                Get.to(ProductDetialsScreen(
                                                  "$image,$index",
                                                  product:
                                                      latestProducts[index],
                                                ));
                                              },
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: latestProducts[
                                                                  index][
                                                              'featured_image'],
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error,
                                                                  color:
                                                                      primaryColor),
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  primaryColor,
                                                              value:
                                                                  downloadProgress
                                                                      .progress,
                                                            ),
                                                          ),
                                                          fit: BoxFit.cover,
                                                          height: 200.0,
                                                        )),
                                                  ])),
                                          Positioned(
                                            right: 7,
                                            top: 7,
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color(0xfff4f4f4)
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: latestProducts[index]
                                                            ['is_fav'] ==
                                                        true
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          var productID =
                                                              latestProducts[
                                                                  index]['id'];
                                                          toggleFavLastest(
                                                              productID);
                                                        },
                                                        child: Icon(
                                                          Icons.favorite,
                                                          size: 18,
                                                          color: Colors.red,
                                                        ))
                                                    : GestureDetector(
                                                        onTap: () {
                                                          var productID =
                                                              latestProducts[
                                                                  index]['id'];
                                                          toggleFavLastest(
                                                              productID);
                                                        },
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          size: 18,
                                                          color: Color(
                                                              0xff3333333),
                                                        ))),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        color: Color(
                                          0xfff4f4f4,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(ProductDetialsScreen(
                                            "$image,$index",
                                            product: latestProducts[index],
                                          ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: Text(
                                            latestProducts[index]['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Color(0xff333333),
                                                fontFamily:
                                                    selectedLanguage == 'en'
                                                        ? 'lucymar'
                                                        : 'LBC'),
                                            textDirection:
                                                selectedLanguage == 'en'
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${latestProducts[index]['price_sdg']}" +
                                                '' +
                                                'SDG'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Color(0xff333333),
                                                fontFamily:
                                                    selectedLanguage == 'en'
                                                        ? 'lucymar'
                                                        : 'LBC'),
                                            textDirection:
                                                selectedLanguage == 'en'
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                            textAlign: selectedLanguage == 'en'
                                                ? TextAlign.left
                                                : TextAlign.right,
                                          ),
                                          latestProducts[index]['in_cart'] ==
                                                  true
                                              ? GestureDetector(
                                                  onTap: () {
                                                    removeFromCart(
                                                        latestProducts[index]
                                                            ['id']);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .remove_shopping_cart_outlined,
                                                    color: Color(0xffcccccc),
                                                  ))
                                              : GestureDetector(
                                                  onTap: () {
                                                    addToCart(
                                                        latestProducts[index]
                                                            ['id']);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .add_shopping_cart_outlined,
                                                    color: primaryColor,
                                                  )),
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                          }),
                    ),
                  ])
                : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Image.asset(
                              "assets/imgs/search.png",
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 0)),
                          Text(
                            'There No Products'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 14,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.right,
                          ),
                        ]),
                      )
                    ],
                  );
  }

  Future getLatestProducts() async {
    lastProductLoader = true;
    var headers = Token == null ? getHeaderNoAuth() : getHeaderAuth();
    var value = await ApiServices.getApi('home', headers: headers);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        lastProductLoader = false;
      });
    });
    value = json.decode(value);
    value = value['latest_products'];
    latestProducts = value;
  }

  Future toggleFavLastest(var productId) async {
    if (Token != null) {
      lastProductLoader = true;
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
        lastProductLoader = false;
        getLatestProducts();
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
        getLatestProducts();
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
}

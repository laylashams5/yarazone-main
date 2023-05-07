import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/product-detials.dart';
import 'package:yarazon/services/api.dart';

List products = [];

class ProductsScreen extends StatefulWidget {
  ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isFirstLoadRunning = false;
  int radioValue = 0;
  bool switchValue = false;
  int page = 1;
  int duration = 0;
  bool _isLoadMoreRunning = false;
  ScrollController _scrollController = ScrollController();
  bool _hasNextPage = true;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    getProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController..addListener(_loadMore);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.removeListener(_loadMore);
    });
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var selectedLanguage = Get.locale?.languageCode.obs;
    return _isFirstLoadRunning == true
        ? Container(
            margin: EdgeInsets.only(
              bottom: 8,
              top: 8,
            ),
            child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  mainAxisExtent: 335,
                ),
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        side: new BorderSide(
                            color: Color(0xfff4f4f4), width: 2.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {},
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 8, right: 8, top: 8),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Skelton(
                                                width: 801, height: 200)),
                                      ),
                                    ])),
                          ],
                        ),
                        Divider(
                          color: Color(
                            0xfff4f4f4,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                            top: 5,
                            left: 8,
                            right: 8,
                          ),
                          child: Skelton(width: 100, height: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: Skelton(width: 100, height: 10)),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          )
        : Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: products.length != 0
                  ? Column(children: [
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 8,
                          top: 8,
                        ),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 3 : 2,
                            mainAxisExtent: 335,
                          ),
                          itemBuilder: (BuildContext context, index) {
                            String? image;
                            return Card(
                              shape: RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Color(0xfff4f4f4), width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Get.to(ProductDetialsScreen(
                                              "$image,$index",
                                              product: products[index],
                                            ));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                      top: 8),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            '${products[index]['featured_image']}',
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                                Icons.error,
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
                                                                    value: downloadProgress
                                                                        .progress,
                                                                  ),
                                                                ),
                                                        height: 200,
                                                        fit: BoxFit.cover),
                                                  ))
                                            ],
                                          )),
                                      Positioned(
                                        right: 7,
                                        top: 7,
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Color(0xfff4f4f4)
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: products[index]['is_fav'] ==
                                                    true
                                                ? GestureDetector(
                                                    onTap: () {
                                                      var productID =
                                                          products[index]['id'];
                                                      toggleFav(productID);
                                                    },
                                                    child: Icon(
                                                      Icons.favorite,
                                                      size: 18,
                                                      color: Colors.red,
                                                    ))
                                                : GestureDetector(
                                                    onTap: () {
                                                      var productID =
                                                          products[index]['id'];
                                                      toggleFav(productID);
                                                    },
                                                    child: Icon(
                                                      Icons.favorite_border,
                                                      size: 18,
                                                      color: Color(0xff3333333),
                                                    ))),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Color(
                                      0xfff4f4f4,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 7,
                                        right: 7,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(ProductDetialsScreen(
                                                "$image,$index",
                                                product: products[index],
                                              ));
                                            },
                                            child: Container(
                                              child: Text(
                                                products[index]['name'],
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
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${products[index]['price_sdg']}" +
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
                                                textAlign:
                                                    selectedLanguage == 'en'
                                                        ? TextAlign.left
                                                        : TextAlign.right,
                                              ),
                                              products[index]['in_cart'] == true
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        removeFromCart(
                                                            products[index]
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
                                                            products[index]
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
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: products.length,
                        ),
                      ),
                      // when the _loadMore function is running
                      // if (_isLoadMoreRunning == true)
                      //   const Padding(
                      //     padding: EdgeInsets.only(top: 10, bottom: 40),
                      //     child: Center(
                      //       child: CircularProgressIndicator(
                      //         color: Colors.orange,
                      //       ),
                      //     ),
                      //   ),
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
                    ),
            ));
  }

  Future getProducts() async {
    _isFirstLoadRunning = true;
    var headers = Token == null ? getHeaderNoAuth() : getHeaderAuth();
    var res = await ApiServices.getApi('products', headers: headers);
    setState(() {
      _isFirstLoadRunning = false;
    });
    res = json.decode(res);
    duration = res['last_page'];
    res = res['data'];
    products = res;
  }

  void _loadMore() async {
    // print('duration $duration');
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      // if (duration) {
      page += 1; // Increase _page by 1
      // }
      try {
        var headers = getHeaderNoAuth();
        var value =
            await ApiServices.getApi('products?page=$page', headers: headers);
        value = json.decode(value);
        value = value['data'];
        final List fetchedProducts = value;
        if (fetchedProducts.isNotEmpty) {
          setState(() {
            products.addAll(fetchedProducts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future toggleFav(var productId) async {
    if (Token != null) {
      _isFirstLoadRunning = true;
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
        _isFirstLoadRunning = false;
        getProducts();
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
        getProducts();
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

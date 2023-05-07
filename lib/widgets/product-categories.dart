import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/product-detials.dart';
import 'package:yarazon/services/api.dart';

class ProductsCategories extends StatefulWidget {
  List products = [];
  String pageName = '';
  String searchKeyword = '';
  ProductsCategories(
      {Key? key,
      required this.products,
      this.pageName = '',
      this.searchKeyword = ''})
      : super(key: key);

  @override
  State<ProductsCategories> createState() => _ProductsCategoriesState();
}

class _ProductsCategoriesState extends State<ProductsCategories> {
  bool _isFirstLoadRunning = false;
  int radioValue = 0;
  bool switchValue = false;
  int page = 1;
  Timer? timer;
  late PersistentBottomSheetController _bottomcontroller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _showBootSheet = false;
  bool _selectedSort0 = false;
  bool _selectedSort1 = false;

  @override
  Widget build(BuildContext context) {
    var selectedLanguage = Get.locale?.languageCode.obs;
    return Directionality(
        textDirection:
            selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            backgroundColor: const Color(0xfffbfbfb),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Products'.tr,
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 16,
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
              actions: [
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            child: const Icon(
                              Icons.sort,
                              size: 20,
                              color: Color(0xff3333333),
                            ),
                            onTap: () {
                              setState(() {
                                _showBootSheet = true;
                              });
                              if (_showBootSheet = true) {
                                _bottomcontroller =
                                    _scaffoldKey.currentState!.showBottomSheet(
                                  (_) => _showBottomSheet(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          topLeft: Radius.circular(16))),
                                );
                              } else {
                                _bottomcontroller.close();
                              }
                            }),
                      ],
                    )),
              ],
            ),
            body: _isFirstLoadRunning == true
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
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Skelton(
                                                        width: 801,
                                                        height: 200)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                        child: widget.products.length != 0
                            ? Column(children: [
                                if (widget.pageName == 'search')
                                  Container(
                                      alignment: selectedLanguage != 'en'
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        'Search Results'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Color(0xff333333),
                                            fontFamily: selectedLanguage == 'en'
                                                ? 'lucymar'
                                                : 'LBC'),
                                        textDirection: selectedLanguage == 'en'
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                      )),
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
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 3
                                              : 2,
                                      mainAxisExtent: 335,
                                    ),
                                    itemBuilder: (BuildContext context, index) {
                                      String? image;
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            side: new BorderSide(
                                                color: Color(0xfff4f4f4),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        elevation: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                          ProductDetialsScreen(
                                                        "$image,$index",
                                                        product: widget
                                                            .products[index],
                                                      ));
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 8,
                                                                    top: 8),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child:
                                                                  CachedNetworkImage(
                                                                      imageUrl:
                                                                          '${widget.products[index]['featured_image']}',
                                                                      errorWidget: (context, url, error) => Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              primaryColor),
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              color: primaryColor,
                                                                              value: downloadProgress.progress,
                                                                            ),
                                                                          ),
                                                                      height:
                                                                          200,
                                                                      fit: BoxFit
                                                                          .cover),
                                                            ))
                                                      ],
                                                    )),
                                                Positioned(
                                                  right: 7,
                                                  top: 7,
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                                  0xfff4f4f4)
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: widget.products[
                                                                      index]
                                                                  ['is_fav'] ==
                                                              true
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                var productID =
                                                                    widget.products[
                                                                            index]
                                                                        ['id'];
                                                                toggleFav(
                                                                    productID);
                                                              },
                                                              child: Icon(
                                                                Icons.favorite,
                                                                size: 18,
                                                                color:
                                                                    Colors.red,
                                                              ))
                                                          : GestureDetector(
                                                              onTap: () {
                                                                var productID =
                                                                    widget.products[
                                                                            index]
                                                                        ['id'];
                                                                toggleFav(
                                                                    productID);
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .favorite_border,
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
                                            Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 7,
                                                  right: 7,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(
                                                            ProductDetialsScreen(
                                                          "$image,$index",
                                                          product: widget
                                                              .products[index],
                                                        ));
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          widget.products[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xff333333),
                                                              fontFamily:
                                                                  selectedLanguage ==
                                                                          'en'
                                                                      ? 'lucymar'
                                                                      : 'LBC'),
                                                          textDirection:
                                                              selectedLanguage ==
                                                                      'en'
                                                                  ? TextDirection
                                                                      .ltr
                                                                  : TextDirection
                                                                      .rtl,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${widget.products[index]['price_sdg']}" +
                                                              '' +
                                                              'SDG'.tr,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xff333333),
                                                              fontFamily:
                                                                  selectedLanguage ==
                                                                          'en'
                                                                      ? 'lucymar'
                                                                      : 'LBC'),
                                                          textDirection:
                                                              selectedLanguage ==
                                                                      'en'
                                                                  ? TextDirection
                                                                      .ltr
                                                                  : TextDirection
                                                                      .rtl,
                                                          textAlign:
                                                              selectedLanguage ==
                                                                      'en'
                                                                  ? TextAlign
                                                                      .left
                                                                  : TextAlign
                                                                      .right,
                                                        ),
                                                        widget.products[index][
                                                                    'in_cart'] ==
                                                                true
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  removeFromCart(
                                                                      widget.products[
                                                                              index]
                                                                          [
                                                                          'id']);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .remove_shopping_cart_outlined,
                                                                  color:
                                                                      Color(0xffcccccc),
                                                                ))
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  addToCart(widget
                                                                          .products[
                                                                      index]['id']);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .add_shopping_cart_outlined,
                                                                  color:
                                                                      primaryColor,
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
                                    itemCount: widget.products.length,
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
                              )),
                  )));
  }

  _showBottomSheet() {
    return _showBootSheet == true
        ? Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200, width: 0),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Sort".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xff333333),
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSort0 = !_selectedSort0;
                          if (_selectedSort0 == true) {
                            _selectedSort1 = false;
                          }
                          _bottomcontroller =
                              _scaffoldKey.currentState!.showBottomSheet(
                            (_) => _showBottomSheet(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16))),
                          );
                          widget.products.sort((a, b) =>
                              a["price_sdg"].compareTo(b["price_sdg"]));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _selectedSort0 == false
                                ? Color(0xfff4f4f4)
                                : primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Price:'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                              ),
                              Text(
                                'lowest to high'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSort1 = !_selectedSort1;
                          if (_selectedSort1 == true) {
                            _selectedSort0 = false;
                          }
                          _bottomcontroller =
                              _scaffoldKey.currentState!.showBottomSheet(
                            (_) => _showBottomSheet(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16))),
                          );
                          widget.products.sort((a, b) =>
                              b["price_sdg"].compareTo(a["price_sdg"]));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: _selectedSort1 == false
                                ? Color(0xfff4f4f4)
                                : primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Price:'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                              ),
                              Text(
                                'highest to low'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff333333),
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC'),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //clear
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 36,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xfff4f4f4), width: 1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Clear'.tr,
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 14,
                                    fontFamily: selectedLanguage == 'en'
                                        ? 'lucymar'
                                        : 'LBC',
                                    fontWeight: FontWeight.w500)),
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )),
              ],
            ),
          )
        : null;
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
        setState(() {
          _isFirstLoadRunning = false;
          searchWithKeyword();
        });
      } else {
        showMessage('removed item to fav!'.tr);
        setState(() {
          _isFirstLoadRunning = false;
          searchWithKeyword();
        });
      }
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  searchWithKeyword() async {
    _isFirstLoadRunning = true;
    if (widget.searchKeyword != '') {
      var headers = getHeaderAuth();
      var value = await ApiServices.getApi(
          'product-search?keyword=${widget.searchKeyword}',
          headers: headers);
      setState(() {
        _isFirstLoadRunning = false;
      });
      value = json.decode(value);
      value = value['data'];
      widget.products = value;
    } else {
      showErrorMessage('The given data was invalid'.tr);
    }
  }

  Future addToCart(var productId) async {
    _isFirstLoadRunning = true;
    if (Token != null) {
      var body = {"product_id": "$productId", "qty": 1};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('cart/add',
          parameters: convertBody, headers: getHeaderAuth());
      showMessage('Added item to cart!'.tr);
      setState(() {
        _isFirstLoadRunning = false;
        searchWithKeyword();
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

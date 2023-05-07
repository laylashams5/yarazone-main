import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/cart.dart';
import 'package:yarazon/screens/home.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yarazon/services/api.dart';
import 'package:intl/intl.dart' as intl;

class ProductDetialsScreen extends StatefulWidget {
  String heroTag;

  var product;
  ProductDetialsScreen(this.heroTag, {required this.product});

  @override
  State<ProductDetialsScreen> createState() =>
      _ProductDetialsScreenState(heroTag);
}

class _ProductDetialsScreenState extends State<ProductDetialsScreen>
    with TickerProviderStateMixin<ProductDetialsScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool selectedColor = false;
  bool selectedSize = false;
  int? colorId;
  int? sizeId;
  int qty = 1;
  List userReviews = [];
  var userData;
  List sizes = [];
  List colors = [];
  List relatedProducts = [];

  var heroTag;

  _ProductDetialsScreenState(this.heroTag);

  var kDefaultPaddin = 20.0;

  int numOfItems = 1;

  double _userRating = 0.0;
  IconData? _selectedIcon;
  List productImages = [];
  bool isLoading = false;
  bool showIconEdit = false;
  bool showIconCancel = false;
  TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getProductImageSlider();
    getUserInfo();
  }

  SizedBox buildOutlineButton({
    IconData? icon,
    var press,
    Color? color,
  }) {
    return SizedBox(
      width: 35,
      height: 25,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xfff4f4f4),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: press,
        child: Icon(
          icon,
          color: Color(0xff333333),
          size: 18,
        ),
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext ctxt) {
    int _current = 0;
    return Scaffold(
      backgroundColor: Color(0xfff4f4f4),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Stack(
                  alignment: selectedLanguage == 'en'
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  children: [
                    Container(
                      child: Hero(
                          tag: widget.product,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CarouselSlider(
                                  items: productImages
                                      .map((e) => Container(
                                            margin: EdgeInsets.all(0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Flexible(
                                                    child: CachedNetworkImage(
                                                      imageUrl: e,
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
                                                          color: primaryColor,
                                                          value:
                                                              downloadProgress
                                                                  .progress,
                                                        ),
                                                      ),
                                                      fit: BoxFit.cover,
                                                      height: 450,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  options: CarouselOptions(
                                      height: 450,
                                      autoPlay: true,
                                      enlargeCenterPage: true,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 1,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      })),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: productImages.map((e) {
                                  int index = productImages.indexOf(e);
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: _current == index
                                          ? Color.fromARGB(248, 231, 130, 8)
                                          : Color.fromARGB(210, 203, 200, 200),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            height: 28,
                            width: 32,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xff333333),
                              ),
                              alignment: Alignment.center,
                              onPressed: () {
                                Get.to(HomeScreen());
                              },
                              iconSize: 14,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 28,
                                  width: 32,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.share_outlined,
                                      color: Color(0xff333333),
                                    ),
                                    alignment: Alignment.center,
                                    onPressed: () {
                                      String text =
                                          // 'Product'.tr + ' : '
                                          // '${baseUrl}products/${widget.product['slug']}'
                                          // "\n"
                                          'Product Image'.tr +
                                              ' : '
                                                  '${widget.product['featured_image']}' +
                                              "\n"
                                                      'Product Name'
                                                  .tr +
                                              ' : '
                                                  '${widget.product['name']} ' +
                                              "\n" '' +
                                              'Product Descripttion'.tr +
                                              '${removeAllHtmlTags(widget.product['description'])}';
                                      String subject =
                                          '${widget.product['featured_image']}';
                                      Share.share(text, subject: subject);
                                    },
                                    iconSize: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: productDetailsSection(),
              )
            ],
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Color(0xfffbfbfb),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                widget.product['id'] == true
                    ? addToCart(widget.product['id'])
                    : removeFromCart(widget.product['id']);
              },
              child: widget.product['id'] == true
                  ? Text('Add To Cart'.tr,
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          fontWeight: FontWeight.w600))
                  : Text('Add To Cart'.tr,
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 14,
                          fontFamily:
                              selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                          fontWeight: FontWeight.w600)),
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
          GestureDetector(
              onTap: () {
                Get.to(Directionality(
                    textDirection: selectedLanguage == 'en'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          title: Text(
                            'Cart'.tr,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 16,
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
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
                        ),
                        resizeToAvoidBottomInset: true,
                        backgroundColor: const Color(0xfffbfbfb),
                        body: CartScreen())));
              },
              child: Container(
                height: 37,
                width: MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.shopping_cart_checkout_outlined,
                  color: Color(0xff333333),
                ),
              )),
        ]),
      ),
    );
  }

  productDetailsSection() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(30))),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            widget.product['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(children: [
                    Row(
                      children: [
                        Text('${widget.product['price_sdg']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                                : TextAlign.right),
                        Text(" " + "SDG",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xff555555),
                                fontFamily: selectedLanguage == 'en'
                                    ? 'lucymar'
                                    : 'LBC'),
                            textDirection: selectedLanguage == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            textAlign: selectedLanguage == 'en'
                                ? TextAlign.left
                                : TextAlign.right)
                      ],
                    ),
                    RatingBarIndicator(
                      rating: _userRating,
                      itemBuilder: (context, index) => Icon(
                        _selectedIcon ?? Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      unratedColor: Colors.amber.withAlpha(50),
                      direction: Axis.horizontal,
                    ),
                  ])
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: <Widget>[
                    buildOutlineButton(
                        icon: Icons.add,
                        color: primaryColor,
                        press: () {
                          setState(() {
                            qty++;
                          });
                        }),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
                      child: Text(
                        "${qty}",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                    ),
                    buildOutlineButton(
                      icon: Icons.remove,
                      color: primaryColor,
                      press: () {
                        if (qty > 1) {
                          setState(() {
                            qty--;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xfff4f4f4),
                    shape: BoxShape.circle,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.product['is_fav'] == true
                            ? GestureDetector(
                                onTap: () {
                                  var productID = widget.product['id'];
                                  toggleFav(productID);
                                },
                                child: Icon(
                                  Icons.favorite,
                                  size: 18,
                                  color: Colors.red,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  var productID = widget.product['id'];
                                  toggleFav(productID);
                                },
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 18,
                                  color: Color(0xff3333333),
                                ))
                      ]),
                )
              ]),
              if (sizes.length != 0)
                SizedBox(
                  height: 15,
                ),
              if (sizes.length != 0)
                //Color
                Container(
                    child: Text(
                  'Available Colors'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xff555555),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                  textDirection: selectedLanguage == 'en'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: selectedLanguage == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                )),
              if (sizes.length != 0)
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 30, minWidth: double.infinity),
                          child: ListView.builder(
                            primary: false,
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
                                      selectedColor = !selectedColor;
                                      if (selectedColor == true) {
                                        colorId = colors[index]['id'];
                                      } else {
                                        colorId;
                                      }
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 30.0,
                                      width: 35.0,
                                      decoration: BoxDecoration(
                                        color: colors[
                                            index], //this is the important line
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),

                                        border: Border.all(
                                            color: selectedColor == true &&
                                                    colors[index]['id'] ==
                                                        colorId
                                                ? Color(0xff333333)
                                                : Colors.transparent,
                                            width: 3),
                                      )));
                            },
                            itemCount: sizes.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ])),
              if (sizes.length != 0) SizedBox(height: 15),
              if (sizes.length != 0)
                //Sizes
                Container(
                    child: Text(
                  'Available Sizes'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xff555555),
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                  textDirection: selectedLanguage == 'en'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: selectedLanguage == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                )),
              if (sizes.length != 0)
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 40, minWidth: double.infinity),
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
                                        sizeId = sizes[index]['id'];
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
                                    margin: EdgeInsets.only(left: leftMargin),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: selectedSize == true &&
                                                    sizes[index]['id'] == sizeId
                                                ? Color(0xff333333)
                                                : Color(0xffeeeeee),
                                            width: 2),
                                        color: Color(0xfffafafa)),
                                  ));
                            },
                            itemCount: sizes.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ])),
              // if (widget.product['description'] != "")
              //   SizedBox(
              //     height: 15,
              //   ),
              // //Description
              // if (widget.product['description'] != "")
              //   Container(
              //       child: Text(
              //     'Description'.tr,
              //     style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 14,
              //         color: Color(0xff555555),
              //         fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
              //     textDirection: selectedLanguage == 'en'
              //         ? TextDirection.ltr
              //         : TextDirection.rtl,
              //     textAlign: selectedLanguage == 'en'
              //         ? TextAlign.left
              //         : TextAlign.right,
              //   )),
              // SizedBox(height: 10),
              // if (widget.product['description'] != '')
              //   Container(
              //     child: Text(
              //       '${removeAllHtmlTags(widget.product['description'])}',
              //       style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           fontSize: 14,
              //           color: Color(0xff444444),
              //           fontFamily:
              //               selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
              //       textDirection: selectedLanguage == 'en'
              //           ? TextDirection.ltr
              //           : TextDirection.rtl,
              //       textAlign: selectedLanguage == 'en'
              //           ? TextAlign.left
              //           : TextAlign.right,
              //     ),
              //   ),

              // SizedBox(
              //   height: 15,
              // ),
              //Reviews
              Container(
                  child: Text(
                'Wirte Review'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff555555),
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                textDirection: selectedLanguage == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                textAlign:
                    selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBar(
                      initialRating: _userRating,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      ratingWidget: RatingWidget(
                          full: const Icon(Icons.star, color: Colors.amber),
                          half: const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),
                          empty: const Icon(
                            Icons.star_outline,
                            color: Colors.amber,
                          )),
                      onRatingUpdate: (value) {
                        setState(() {
                          _userRating = value;
                        });
                      }),
                  Text(
                    _userRating != null ? _userRating.toString() : 'Rate it!',
                    style:
                        const TextStyle(color: Color(0xff333333), fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff4f4f4),
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
                  controller: _commentController,
                  textAlign: selectedLanguage == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Color(0xffccccccc)),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  maxLines: null,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (showIconCancel == false && showIconEdit == false)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      rateProduct();
                    },
                    child: Text('Wirte Review'.tr,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC')),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffeeeeee))),
                  ),
                ),
              if (showIconCancel == true && showIconEdit == true)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      editRate();
                    },
                    child: Text('Edit Review'.tr,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC')),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffeeeeee))),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              //Users Reviews
              Container(
                  child: Text(
                'Users Reviews'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff555555),
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                textDirection: selectedLanguage == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                textAlign:
                    selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              )),
              SizedBox(height: 10),
              userReviews.length == 0
                  ? Container(
                      child: Text(
                        'No Reviews'.tr,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                      ),
                    )
                  : ListView.builder(
                      primary: false,
                      itemCount: userReviews.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xffcccccc), width: 1))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                              'assets/imgs/profile.png',
                                              width: 50,
                                              height: 50,
                                            )),
                                        Column(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  '${userReviews[index]['user_name']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? 'lucymar'
                                                              : 'LBC'),
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  '${userReviews[index]['created_at']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff6666666),
                                                      fontSize: 12,
                                                      fontFamily:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? 'lucymar'
                                                              : 'LBC'),
                                                )),
                                          ],
                                        ),
                                      ]),
                                  if (userData?['name'] ==
                                      userReviews[index]['user_name'])
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        showIconCancel == false
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    var rating = double.parse(
                                                        userReviews[index]
                                                            ['rating']);
                                                    _userRating = rating;
                                                    _commentController.text =
                                                        userReviews[index]
                                                            ['comment'];
                                                  });
                                                  setState(() {
                                                    showIconCancel = true;
                                                    showIconEdit = true;
                                                  });
                                                },
                                                child: Icon(Icons.edit_outlined,
                                                    color: Colors.greenAccent))
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _userRating = 0.0;
                                                    _commentController.text =
                                                        '';
                                                    showIconCancel = false;
                                                    showIconEdit = false;
                                                  });
                                                },
                                                child: Icon(Icons.clear,
                                                    color: Color(0xff333333))),
                                        GestureDetector(
                                            onTap: () {
                                              deleteRate(
                                                  userReviews[index]['id']);
                                            },
                                            child: Icon(Icons.delete_outline,
                                                color: Colors.red)),
                                      ],
                                    )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RatingBarIndicator(
                                rating: double.parse(
                                    '${userReviews[index]['rating']}'),
                                itemBuilder: (context, index) => Icon(
                                  _selectedIcon ?? Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(
                                  '${userReviews[index]['comment']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xff444444),
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
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        );
                      }),
              SizedBox(
                height: 15,
              ),
              if (relatedProducts.length != 0)
                //Related Products
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      child: Text(
                    'Same Products'.tr,
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
                  )),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .5,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisExtent: 200,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                        padding: EdgeInsets.only(left: 5, right: 5),
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              Get.offAll(ProductDetialsScreen(
                                                "$image,$index",
                                                product: relatedProducts[index],
                                              ));
                                            },
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: CachedNetworkImage(
                                                        imageUrl: relatedProducts[
                                                                index]
                                                            ['featured_image'],
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                    downloadProgress) =>
                                                                Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
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
                                          top: 0,
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff4f4f4)
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: relatedProducts[index]
                                                          ['is_fav'] ==
                                                      true
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        var productID =
                                                            relatedProducts[
                                                                index]['id'];
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
                                                            relatedProducts[
                                                                index]['id'];
                                                        toggleFav(productID);
                                                      },
                                                      child: Icon(
                                                        Icons.favorite_border,
                                                        size: 18,
                                                        color:
                                                            Color(0xff3333333),
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
                                        Get.offAll(ProductDetialsScreen(
                                          "$image,$index",
                                          product: relatedProducts[index],
                                        ));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(bottom: 5, top: 5),
                                        child: Text(
                                          relatedProducts[index]['name'],
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
                                          "${relatedProducts[index]['price_sdg']}" +
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
                                        relatedProducts[index]['in_cart'] ==
                                                true
                                            ? GestureDetector(
                                                onTap: () {
                                                  removeFromCart(
                                                      relatedProducts[index]
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
                                                      relatedProducts[index]
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
                ]),

              SizedBox(
                height: 60,
              ),
            ],
          ),
        ));
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
    }
  }

  Future toggleFav(var productId) async {
    if (Token != null) {
      isLoading = true;
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
        isLoading = false;
        widget.product['is_fav'] = !widget.product['is_fav'];
        getProductImageSlider();
      });
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future rateProduct() async {
    if (Token != null) {
      isLoading = true;
      int userRate = _userRating.toInt();
      var body = {
        "rating": userRate,
        "comment": _commentController.text,
        "user_id": userId
      };
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi(
          'products/${widget.product['id']}/reviews/create',
          parameters: convertBody,
          headers: getHeaderAuth());
      if (Token != null && _commentController.text != '' || userRate != 0) {
        setState(() {
          isLoading = false;
          getProductImageSlider();
          _userRating = 0.0;
          _commentController.text = '';
        });
        showMessage('Rated Successfully'.tr);
      } else {
        showErrorMessage('The given data was invalid'.tr);
      }
      logger.e(value);
    } else {
      showErrorMessage('You should login'.tr);
      Get.to(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  editRate() async {
    var reviews =
        userReviews.where((el) => el['user_name'] == userData?['name']);
    List reviewList = reviews.toList();
    var rateId = reviewList[0]['id'];
    isLoading = true;
    int userRate = _userRating.toInt();
    var body = {
      "rating": userRate,
      "comment": _commentController.text,
    };
    final convertBody = json.encode(body);
    var value = await ApiServices.postApi('products/reviews/${rateId}',
        parameters: convertBody, headers: getHeaderAuth());
    if (Token != null && _commentController.text != '' || userRate != 0) {
      setState(() {
        isLoading = false;
        getProductImageSlider();
        _userRating = 0.0;
        _commentController.text = '';
        showIconCancel = false;
        showIconEdit = false;
      });
      showMessage('Rated edited successfully'.tr);
    } else {
      showErrorMessage('The given data was invalid'.tr);
    }
    logger.e(value);
  }

  deleteRate(var rateId) async {
    isLoading = true;
    var body = {};
    final convertBody = json.encode(body);
    var value = await ApiServices.deleteApi('products/reviews/${rateId}',
        parameters: convertBody, headers: getHeaderAuth());
    if (Token != null) {
      setState(() {
        isLoading = false;
        getProductImageSlider();
        _userRating = 0.0;
        _commentController.text = '';
      });
      showMessage('Rated deleted successfully'.tr);
    } else {
      showErrorMessage('The given data was invalid'.tr);
    }
    logger.e(value);
  }

  Future getProductImageSlider() async {
    print(widget.product['slug']);
    isLoading = true;
    var headers = Token == null ? getHeaderNoAuth() : getHeaderAuth();
    var value = await ApiServices.getApi('products/${widget.product['slug']}',
        headers: headers);
    value = json.decode(value);
    print(' detials ${value['data']}');
    var featured_image = value['data']['featured_image'];
    widget.product['description'] = value['data']['description'];
    if (value['data']['image_gallery'] == null) {
      productImages.insert(0, "$featured_image");
    }
    if (value['data']['image_gallery'] != null) {
      productImages = value['data']['image_gallery'];
    }
    if (value['data']['image_gallery'] != null) {
      productImages.insert(0, "$featured_image");
    }
    relatedProducts = value['data']['related_products'];
    userReviews = value['data']['reviews'];
    setState(() {
      isLoading = false;
    });
  }

  Future addToCart(var productId) async {
    if (Token != null) {
      var body = {"product_id": "$productId", "qty": '${qty}'};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('cart/add',
          parameters: convertBody, headers: getHeaderAuth());
      showMessage('Added item to cart!'.tr);
      getProductImageSlider();
    } else {
      showErrorMessage('You should login'.tr);
      Get.to(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future removeFromCart(var productId) async {
    showMessage("You can't add product twice".tr);
  }
}

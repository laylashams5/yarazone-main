import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/models/cart.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/services/api.dart';
import 'dart:ui' as ui;

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  final TextEditingController _addressController = TextEditingController();
  bool isLoading = false;
  List<CartItem> itemsCart = [];
  double totalCartValue = 0;
  @override
  void initState() {
    super.initState();
    if (Token != null) {
      getItemsCart();
    }
  }

  void calculateTotal() {
    totalCartValue = 0;
    itemsCart.forEach((f) {
      double price = double.parse((f.price_sdg).toString());
      double qty = double.parse((f.qty).toString());
      print(price.runtimeType);
      print(qty.runtimeType);
      totalCartValue += price * qty;
    });
  }

  SizedBox buildOutlineButton({
    IconData? icon,
    var press,
    Color? color,
  }) {
    return SizedBox(
      width: 30,
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

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: selectedLanguage == 'en'
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Skelton(
                            height: 10,
                            width: 80,
                          ),
                          margin: EdgeInsets.only(left: 12, top: 4, bottom: 10),
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: Skelton(
                              width: 100,
                              height: 10,
                            ))
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, i) {
                        return Container(
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color(0xffeeeeee),
                                    blurRadius: 15,
                                    spreadRadius: 10),
                              ],
                            ),
                            child: Row(children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    right: 0, left: 0, top: 8, bottom: 8),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Skelton(
                                  width: 50,
                                  height: 10,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Skelton(
                                          width: 200,
                                          height: 10,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Skelton(
                                              width: 50,
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Skelton(
                                                    width: 20,
                                                    height: 10,
                                                  ),
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 2,
                                                              right: 12,
                                                              left: 12),
                                                      child: Skelton(
                                                        width: 30,
                                                        height: 10,
                                                      )),
                                                  Skelton(
                                                    width: 20,
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 100,
                              )
                            ]));
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Skelton(
                                  width: 100,
                                  height: 10,
                                ),
                              ),
                              Container(
                                child: Skelton(
                                  width: 100,
                                  height: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 36,
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(''),
                              style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey.withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    )
                  ],
                )))
        : SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(children: [
                  itemsCart.length == 0
                      ? Container(
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
                                "assets/imgs/cart.png",
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 0)),
                            Text(
                              'The Cart Is Empty'.tr,
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
                      : Column(
                          children: [
                            createSubTitle(),
                            createCartList(),
                            footer(context)
                          ],
                        )
                ])));
  }

  footer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  "Total".tr,
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                  textDirection: selectedLanguage == 'en'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: selectedLanguage == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                ),
              ),
              Container(
                child: Text(
                  "${totalCartValue.toStringAsFixed(2)}" + '  ' + 'SDG'.tr,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                  textDirection: selectedLanguage == 'en'
                      ? TextDirection.rtl
                      : TextDirection.rtl,
                  textAlign: selectedLanguage == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
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
            margin: EdgeInsets.only(right: 0, left: 0),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: _addressController,
              textAlign:
                  selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              decoration: InputDecoration(
                hintText: 'Write your address'.tr,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff333333),
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.transparent),
                ),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: null,
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 36,
            margin: const EdgeInsets.only(right: 20, left: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ElevatedButton(
              onPressed: () {checkout();},
              child: Text('Buy Now'.tr,
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
          SizedBox(height: 8),
        ],
      ),
    );
  }

  createSubTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment:
              selectedLanguage == 'en' ? Alignment.topLeft : Alignment.topRight,
          child: Text(
            'Count'.tr + ' ' + '(${itemsCart.length})',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
            textDirection: selectedLanguage == 'en'
                ? TextDirection.rtl
                : TextDirection.ltr,
            textAlign:
                selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
          ),
          margin: EdgeInsets.only(left: 12, top: 4, bottom: 10),
        ),
        GestureDetector(
            onTap: () {
              ConfirmEmptyCart(context);
            },
            child: Icon(
              Icons.remove_shopping_cart_outlined,
              size: 25,
              color: primaryColor,
            ))
      ],
    );
  }

  ConfirmEmptyCart(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton.icon(
      icon: Icon(
        Icons.clear,
        color: Color(0xff333333),
      ),
      label: Text(
        "Cancel".tr,
        style: TextStyle(
            color: Color(0xff333333),
            fontSize: 16,
            fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton.icon(
      icon: Icon(
        Icons.done,
        color: Color(0xff333333),
      ),
      label: Text(
        "Confirm".tr,
        style: TextStyle(
            color: Color(0xff333333),
            fontSize: 14,
            fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
      ),
      onPressed: () {
        emptyCart();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: primaryColor,
      content: Text(
        "Are you sure to empty the cart".tr,
        style: TextStyle(
            color: Color(0xff333333),
            fontSize: 16,
            fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return Directionality(
            textDirection: selectedLanguage == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Dialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(15),
                child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: alert)));
      },
    );
  }

  createCartList() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: itemsCart.length,
        itemBuilder: (context, i) {
          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color(0xffeeeeee),
                        blurRadius: 15,
                        spreadRadius: 10),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            right: 0, left: 0, top: 8, bottom: 8),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error, color: primaryColor),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                  imageUrl:
                                      "${itemsCart[i].featured_image}")),
                        )),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 4),
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "${itemsCart[i].product_name}",
                                  maxLines: 4,
                                  style: TextStyle(
                                      color: Color(0xff333333),
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
                                  softWrap: false,
                                ),
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "${itemsCart[i].price_sdg}" +
                                        '  ' +
                                        'SDG'.tr,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: selectedLanguage == 'en'
                                            ? 'lucymar'
                                            : 'LBC'),
                                    textDirection: selectedLanguage == 'en'
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    textAlign: selectedLanguage == 'en'
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      children: <Widget>[
                                        buildOutlineButton(
                                          press: () {
                                            setState(() {
                                              var cartId = itemsCart[i].id;
                                              var cartQty = int.parse(itemsCart[i].qty);
                                              cartQty++;
                                              editCart(cartId, cartQty);
                                            });
                                          },
                                          icon: Icons.add,
                                          color: Color(0xff333333),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 2, right: 8, left: 8),
                                          child: Text(
                                            "${itemsCart[i].qty}",
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 14,
                                                fontFamily:
                                                    selectedLanguage == 'en'
                                                        ? 'lucymar'
                                                        : 'LBC'),
                                            textDirection:
                                                selectedLanguage == 'en'
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                            textAlign: selectedLanguage == 'en'
                                                ? TextAlign.left
                                                : TextAlign.right,
                                          ),
                                        ),
                                        buildOutlineButton(
                                          icon: Icons.remove,
                                          color: Color(0xff333333),
                                          press: () {
                                            if (int.parse(itemsCart[i].qty) >
                                                1) {
                                              setState(() {
                                                var cartId = itemsCart[i].id;
                                                var cartQty = 
                                                    int.parse(itemsCart[i].qty);
                                                cartQty--;
                                                editCart(cartId, cartQty);
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 100,
                    )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      removeFromCart(itemsCart[i].id);
                    });
                  },
                  child: Align(
                    alignment: selectedLanguage == 'en'
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 10, top: 8),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: primaryColor),
                    ),
                  )),
            ],
          );
        });
  }

  Future getItemsCart() async {
    isLoading = true;
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('cart', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];    
    var content = value as List<dynamic>;
    itemsCart = content
        .map((model) => CartItem.fromJson(model as Map<String, dynamic>))
        .toList();
    calculateTotal();
    print('itemsCart ${itemsCart.length}');
  }

  Future getItemCartWithoutLoader() async {
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('cart', headers: headers);
    setState(() {});
    value = json.decode(value);
    value = value['data'];
    var content = value as List<dynamic>;
    itemsCart = content
        .map((model) => CartItem.fromJson(model as Map<String, dynamic>))
        .toList();
    calculateTotal();
  }

  Future checkout() async {
    print('itemsCart ${_addressController.text}');
    if (Token != null) {
      isLoading = true;
      var body = {"address": _addressController.text, "cart_products": itemsCart};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('checkout',
          parameters: convertBody, headers: getHeaderAuth());
      var decode = json.decode(value);
      print(decode);
      showMessage('Purchased successfully'.tr);
      setState(() {
        isLoading = false;
        getItemsCart();
      });
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future removeFromCart(var productId) async {
    if (Token != null) {
      isLoading = true;
      var body = {
        "item_id": "$productId",
      };
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('cart/delete',
          parameters: convertBody, headers: getHeaderAuth());
      var decode = json.decode(value);
      showMessage('removed item to cart!'.tr);
      setState(() {
        isLoading = false;
        getItemsCart();
      });
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future editCart(var productId, var qty) async {
    if (Token != null) {
      var body = {"item_id": "$productId", "qty": "$qty"};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('cart/edit',
          parameters: convertBody, headers: getHeaderAuth());
      setState(() {
        getItemCartWithoutLoader();
      });
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future emptyCart() async {
    if (Token != null) {
      isLoading = true;
      var body = {};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('cart/empty',
          parameters: convertBody, headers: getHeaderAuth());
      var decode = json.decode(value);
      showMessage('Cart empty'.tr);
      setState(() {
        isLoading = false;
        getItemsCart();
      });
      showMessage(decode);
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }
}

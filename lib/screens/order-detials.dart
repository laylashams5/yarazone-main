import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/orders-history.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routeName = '/order-detials';
  var selectedLanguage = Get.locale?.languageCode.obs;
  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    print(orderId);
    final selectedOrder =
        orderData.firstWhere((order) => order['refrence_number'] == orderId);
        print(selectedOrder);
    List products=[];
    List productsFly=[];
     products = selectedOrder['products'];
     productsFly = selectedOrder['products_on_the_fly'];
    return Directionality(
        textDirection:
            selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color(0xfffbfbfb),
            appBar: AppBar(
              title: Text(
                'Order Number'.tr + ' ' + '$orderId',
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 14,
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                textDirection: selectedLanguage == 'en'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlign:
                    selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 14,
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
            body: SingleChildScrollView(
                child: Column(children: [
              SizedBox(
                height: 10,
              ),
             if(productsFly.length!=0)  
             ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: productsFly.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 15, top: 20),
                      decoration: BoxDecoration(
                          color: Color(0xfff4f4f4),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var url = '${productsFly[index]['link']}';
                              if (await canLaunch(url)) {
                                url != '#' ? await launch(url) : null;
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff333333),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(bottom: 8),
                              child: Text(
                                'View Product'.tr,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffffffff),
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
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      'Product'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
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
                                    ),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 3, right: 3),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        '${productsFly[index]['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
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
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      'َQty'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
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
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          // color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        selectedLanguage == 'en'
                                            ? '${productsFly[index]['qty']}'
                                            : replaceFarsiNumber(
                                                '${productsFly[index]['qty']}'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      'Weight'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
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
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          // color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        selectedLanguage == 'en'
                                            ? '${productsFly[index]['weight']}'
                                            : replaceFarsiNumber(
                                                '${productsFly[index]['weight']}'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      'Price'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
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
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        selectedLanguage == 'en'
                                            ? '${productsFly[index]['price_sdg']}'
                                            : replaceFarsiNumber(
                                                '${productsFly[index]['price_sdg']}'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(3),
                                child: Text(
                                  'Specifications'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
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
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    {productsFly[index]['specs']} == '' || {productsFly[index]['specs']} == null
                                        ? 'No Specifications'.tr
                                        : '${productsFly[index]['specs']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
             if(products.length!=0)  
             ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 15, top: 20),
                      decoration: BoxDecoration(
                          color: Color(0xfff4f4f4),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
      
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      'Product'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
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
                                    ),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 3, right: 3),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        '${products[index]['product']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
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
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      'َQty'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
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
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          // color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        selectedLanguage == 'en'
                                            ? '${products[index]['qty']}'
                                            : replaceFarsiNumber(
                                                '${products[index]['qty']}'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      'Price'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
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
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        selectedLanguage == 'en'
                                            ? '${products[index]['sub_total']}'
                                            : replaceFarsiNumber(
                                                '${products[index]['sub_total']}'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(3),
                                child: Text(
                                  'Specifications'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
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
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    {products[index]['specs']} == '' || {products[index]['specs']} == null
                                        ? 'No Specifications'.tr
                                        : '${products[index]['specs']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 15,
              )
            ]))));
  }
}

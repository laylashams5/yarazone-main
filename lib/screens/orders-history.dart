import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/order-detials.dart';
import 'package:yarazon/services/api.dart';

List orderData = [];

class OrdersHistoryScreen extends StatefulWidget {
  OrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:
            selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color(0xfffbfbfb),
            appBar: AppBar(
              title: Text(
                'Orders History'.tr,
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 16,
                    fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
              ),
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
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: orderData.length == 0 && isLoading == false
                  ? Column(
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
                              'There No Orders'.tr,
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
                    )
                  : Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: orderData.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    OrderDetailsScreen.routeName,
                                    arguments: orderData[index]
                                        ['refrence_number'],
                                  );
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xffccccccc),
                                                  blurRadius: 4,
                                                  offset: Offset(4, 8),
                                                )
                                              ],
                                              color: Color(0xfff4f4f4),
                                            ),
                                            padding: EdgeInsets.all(15),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons.align_vertical_center_outlined,
                                                      size: 14,
                                                      color: Color(0xff333333),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10)),
                                                    Text(
                                                      'Order Number'.tr,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff333333),
                                                          fontFamily:
                                                              selectedLanguage ==
                                                                      'en'
                                                                  ? 'lucymar'
                                                                  : 'LBC'),
                                                      textDirection:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? TextDirection
                                                                  .rtl
                                                              : TextDirection
                                                                  .ltr,
                                                      textAlign:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? TextAlign.center
                                                              : TextAlign
                                                                  .center,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  selectedLanguage == 'en'
                                                      ? '${orderData[index]['refrence_number']}'
                                                      : replaceFarsiNumber(
                                                          '${orderData[index]['refrence_number']}'),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff333333),
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
                                                          ? TextAlign.center
                                                          : TextAlign.center,
                                                )
                                              ],
                                            )),
                                        Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xffccccccc),
                                                  blurRadius: 4,
                                                  offset: Offset(4, 8),
                                                )
                                              ],
                                              color: Color(0xfff4f4f4),
                                            ),
                                            padding: EdgeInsets.all(15),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons.post_add_rounded,
                                                      size: 14,
                                                      color: Color(0xff333333),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10)),
                                                    Text(
                                                      'Products Count'.tr,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff333333),
                                                          fontFamily:
                                                              selectedLanguage ==
                                                                      'en'
                                                                  ? 'lucymar'
                                                                  : 'LBC'),
                                                      textDirection:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? TextDirection
                                                                  .rtl
                                                              : TextDirection
                                                                  .ltr,
                                                      textAlign:
                                                          selectedLanguage ==
                                                                  'en'
                                                              ? TextAlign.center
                                                              : TextAlign
                                                                  .center,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  selectedLanguage == 'en'
                                                      ? '${orderData[index]['products_count']}'
                                                      : replaceFarsiNumber(
                                                          '${orderData[index]['products_count']}'),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff333333),
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
                                                          ? TextAlign.center
                                                          : TextAlign.center,
                                                )
                                              ],
                                            )),
                                        Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xffccccccc),
                                                  blurRadius: 4,
                                                  offset: Offset(4, 8),
                                                )
                                              ],
                                              color: Color(0xfff4f4f4),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .backup_table_rounded,
                                                        size: 14,
                                                        color:
                                                            Color(0xff333333),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10)),
                                                      Text(
                                                        'Order Status'.tr,
                                                        style: TextStyle(
                                                            fontSize: 14,
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
                                                                    .rtl
                                                                : TextDirection
                                                                    .ltr,
                                                        textAlign:
                                                            selectedLanguage ==
                                                                    'en'
                                                                ? TextAlign
                                                                    .center
                                                                : TextAlign
                                                                    .center,
                                                      ),
                                                    ]),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: orderData[index]
                                                                  ['status'] ==
                                                              'Pending'
                                                          ? Colors.grey
                                                              .withOpacity(0.3)
                                                          : Colors.greenAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    '${orderData[index]['status']}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff333333),
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
                                                )
                                              ],
                                            )),
                                        Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xffccccccc),
                                                    blurRadius: 4,
                                                    offset: Offset(4, 8),
                                                  )
                                                ],
                                                color: Color(0xfff4f4f4),
                                              ),
                                              child: Accordion(
                                                paddingListBottom: 0,
                                                headerBorderRadius: 5,
                                                headerBackgroundColorOpened:
                                                    Color(0xff333333),
                                                headerPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7,
                                                        horizontal: 7),
                                                sectionOpeningHapticFeedback:
                                                    SectionHapticFeedback.heavy,
                                                sectionClosingHapticFeedback:
                                                    SectionHapticFeedback.light,
                                                children: [
                                                  AccordionSection(
                                                      contentBorderColor:
                                                          Colors.transparent,
                                                      headerBackgroundColor:
                                                          Color(0xff333333),
                                                      contentBackgroundColor:
                                                          Color(0xfff4f4f4),
                                                      paddingBetweenClosedSections:
                                                          0,
                                                      isOpen: false,
                                                      leftIcon: Icon(
                                                          size: 14,
                                                          Icons
                                                              .list_alt_outlined,
                                                          color: Color(
                                                              0xfff4f4f4)),
                                                      header: Text(
                                                          'Order Detials'.tr,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffffffff),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  selectedLanguage ==
                                                                          'en'
                                                                      ? 'lucymar'
                                                                      : 'LBC')),
                                                      content: Column(
                                                        children: [
                                                          if (orderData[index][
                                                                  'discount'] ==
                                                              0)
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.money_rounded,
                                                                            size:
                                                                                14,
                                                                            color:
                                                                                Color(0xff333333),
                                                                          ),
                                                                          Padding(
                                                                              padding: EdgeInsets.only(left: 10, right: 10)),
                                                                          Text(
                                                                            'Price'.tr,
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Color(0xff333333),
                                                                                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                                                                            textDirection: selectedLanguage == 'en'
                                                                                ? TextDirection.rtl
                                                                                : TextDirection.ltr,
                                                                            textAlign: selectedLanguage == 'en'
                                                                                ? TextAlign.center
                                                                                : TextAlign.center,
                                                                          ),
                                                                        ]),
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        selectedLanguage ==
                                                                                'en'
                                                                            ? '${orderData[index]['total_before_discount']}'
                                                                            : replaceFarsiNumber('${orderData[index]['total_before_discount']}'),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color: Color(
                                                                                0xff333333),
                                                                            fontFamily: selectedLanguage == 'en'
                                                                                ? 'lucymar'
                                                                                : 'LBC'),
                                                                        textDirection: selectedLanguage ==
                                                                                'en'
                                                                            ? TextDirection.rtl
                                                                            : TextDirection.ltr,
                                                                        textAlign: selectedLanguage ==
                                                                                'en'
                                                                            ? TextAlign.center
                                                                            : TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          if (orderData[index][
                                                                  'discount'] ==
                                                              0)
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.money_rounded,
                                                                            size:
                                                                                14,
                                                                            color:
                                                                                Color(0xff333333),
                                                                          ),
                                                                          Padding(
                                                                              padding: EdgeInsets.only(left: 10, right: 10)),
                                                                          Text(
                                                                            'Discount'.tr,
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Color(0xff333333),
                                                                                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                                                                            textDirection: selectedLanguage == 'en'
                                                                                ? TextDirection.rtl
                                                                                : TextDirection.ltr,
                                                                            textAlign: selectedLanguage == 'en'
                                                                                ? TextAlign.center
                                                                                : TextAlign.center,
                                                                          ),
                                                                        ]),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        selectedLanguage ==
                                                                                'en'
                                                                            ? '${orderData[index]['discount']}'
                                                                            : replaceFarsiNumber('${orderData[index]['discount']}'),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color: Colors
                                                                                .white,
                                                                            fontFamily: selectedLanguage == 'en'
                                                                                ? 'lucymar'
                                                                                : 'LBC'),
                                                                        textDirection: selectedLanguage ==
                                                                                'en'
                                                                            ? TextDirection.rtl
                                                                            : TextDirection.ltr,
                                                                        textAlign: selectedLanguage ==
                                                                                'en'
                                                                            ? TextAlign.center
                                                                            : TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          if (orderData[index][
                                                                  'discount'] !=
                                                              0)
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Color(
                                                                                0xffcccccc),
                                                                            width:
                                                                                1))),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.money_rounded,
                                                                            size:
                                                                                14,
                                                                            color:
                                                                                Color(0xff333333),
                                                                          ),
                                                                          Padding(
                                                                              padding: EdgeInsets.only(left: 10, right: 10)),
                                                                          Text(
                                                                            'Total'.tr,
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Color(0xff333333),
                                                                                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                                                                            textDirection: selectedLanguage == 'en'
                                                                                ? TextDirection.rtl
                                                                                : TextDirection.ltr,
                                                                            textAlign: selectedLanguage == 'en'
                                                                                ? TextAlign.center
                                                                                : TextAlign.center,
                                                                          ),
                                                                        ]),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xff333333),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        selectedLanguage ==
                                                                                'en'
                                                                            ? '${orderData[index]['total']}'
                                                                            : replaceFarsiNumber('${orderData[index]['total']}'),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color: Colors
                                                                                .white,
                                                                            fontFamily: selectedLanguage == 'en'
                                                                                ? 'lucymar'
                                                                                : 'LBC'),
                                                                        textDirection: selectedLanguage ==
                                                                                'en'
                                                                            ? TextDirection.rtl
                                                                            : TextDirection.ltr,
                                                                        textAlign: selectedLanguage ==
                                                                                'en'
                                                                            ? TextAlign.center
                                                                            : TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          orderData[index][
                                                                      'is_replacement'] ==
                                                                  false
                                                              ? Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Container(
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                                                      padding: EdgeInsets.all(5),
                                                                      child: orderData[index]['is_replacement'] == false
                                                                          ? Text('')
                                                                          : Text(
                                                                              'Is Replaced'.tr,
                                                                              style: TextStyle(color: Color(0xff333333), fontSize: 14, fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                                                                              textDirection: selectedLanguage == 'en' ? TextDirection.rtl : TextDirection.ltr,
                                                                              textAlign: selectedLanguage == 'en' ? TextAlign.left : TextAlign.right,
                                                                            )))
                                                              : Text(''),
                                                          if (orderData[index][
                                                                  'total_after_replacement'] !=
                                                              0)
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.money_rounded,
                                                                            size:
                                                                                14,
                                                                            color:
                                                                                Color(0xff333333),
                                                                          ),
                                                                          Padding(
                                                                              padding: EdgeInsets.only(left: 10, right: 10)),
                                                                          Text(
                                                                            'Total After Replacement'.tr,
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Color(0xff333333),
                                                                                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                                                                            textDirection: selectedLanguage == 'en'
                                                                                ? TextDirection.rtl
                                                                                : TextDirection.ltr,
                                                                            textAlign: selectedLanguage == 'en'
                                                                                ? TextAlign.left
                                                                                : TextAlign.right,
                                                                          ),
                                                                        ]),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xff333333),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        '${orderData[index]['total_after_replacement']}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color: Colors
                                                                                .white,
                                                                            fontFamily: selectedLanguage == 'en'
                                                                                ? 'lucymar'
                                                                                : 'LBC'),
                                                                        textDirection: selectedLanguage ==
                                                                                'en'
                                                                            ? TextDirection.rtl
                                                                            : TextDirection.ltr,
                                                                        textAlign: selectedLanguage ==
                                                                                'en'
                                                                            ? TextAlign.left
                                                                            : TextAlign.right,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15),
                                                              color: Color(
                                                                  0xfff4f4f4),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .location_on_outlined,
                                                                          size:
                                                                              14,
                                                                          color:
                                                                              Color(0xff333333),
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 10, right: 10)),
                                                                        Text(
                                                                          'Address'
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Color(0xff333333),
                                                                            fontFamily: selectedLanguage == 'en'
                                                                                ? 'lucymar'
                                                                                : 'LBC',
                                                                          ),
                                                                          textDirection: selectedLanguage == 'en'
                                                                              ? TextDirection.rtl
                                                                              : TextDirection.ltr,
                                                                          textAlign: selectedLanguage == 'en'
                                                                              ? TextAlign.center
                                                                              : TextAlign.center,
                                                                        ),
                                                                      ]),
                                                                  Text(
                                                                    '${orderData[index]['address']}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff333333),
                                                                        fontFamily: selectedLanguage ==
                                                                                'en'
                                                                            ? 'lucymar'
                                                                            : 'LBC'),
                                                                    textDirection: selectedLanguage ==
                                                                            'en'
                                                                        ? TextDirection
                                                                            .rtl
                                                                        : TextDirection
                                                                            .ltr,
                                                                    textAlign: selectedLanguage ==
                                                                            'en'
                                                                        ? TextAlign
                                                                            .center
                                                                        : TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              )),
                                                          Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15),
                                                              color: Color(
                                                                  0xfff4f4f4),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .location_city_outlined,
                                                                          size:
                                                                              14,
                                                                          color:
                                                                              Color(0xff333333),
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 10, right: 10)),
                                                                        Text(
                                                                          'City'
                                                                              .tr,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xff333333),
                                                                              fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
                                                                          textDirection: selectedLanguage == 'en'
                                                                              ? TextDirection.rtl
                                                                              : TextDirection.ltr,
                                                                          textAlign: selectedLanguage == 'en'
                                                                              ? TextAlign.center
                                                                              : TextAlign.center,
                                                                        ),
                                                                      ]),
                                                                  Container(
                                                                    child: Text(
                                                                      '${orderData[index]['city']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Color(
                                                                              0xff333333),
                                                                          fontFamily: selectedLanguage == 'en'
                                                                              ? 'lucymar'
                                                                              : 'LBC'),
                                                                      textDirection: selectedLanguage ==
                                                                              'en'
                                                                          ? TextDirection
                                                                              .rtl
                                                                          : TextDirection
                                                                              .ltr,
                                                                      textAlign: selectedLanguage ==
                                                                              'en'
                                                                          ? TextAlign
                                                                              .center
                                                                          : TextAlign
                                                                              .center,
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )));
                          }),
                      isLoading == true
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 100, right: 100, top: 100),
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: primaryColor,
                                size: 30,
                              ),
                            )
                          : Text(''),
                    ]),
            )));
  }

  Future getOrderData() async {
    isLoading = true;
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('profile/orders', headers: headers);
    if (Token != null) {
      print('Token $Token');
      setState(() {
        isLoading = false;
      });
      value = json.decode(value);
      value = value['data'];
      orderData = value;
      // print('orders ${orderData[0]['prodxes']}');
      // orderData = Order.fromJson(value);
    }
  }
}

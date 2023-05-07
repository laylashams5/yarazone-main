import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/product-detials.dart';
import 'package:yarazon/services/api.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool isLoading = false;
  List wishes = [];
  var userData;
  @override
  void initState() {
    print(Token);
    super.initState();
    getWishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbfbfb),
      appBar: AppBar(
        title: Text(
          'Favorite'.tr,
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
      body: Container(
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: isLoading == true
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
                        mainAxisExtent: 290,
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
                                child: Skelton(width: 100, height: 10),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: [
                    wishes.length == 0
                        ? Container(
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Column(children: [
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Image.asset(
                                    'assets/imgs/emptywishlist.png'),
                              ),
                              Padding(padding: EdgeInsets.only(top: 0)),
                              Text(
                                'There No Fav'.tr,
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
                        : Container(
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
                                    MediaQuery.of(context).size.width > 600
                                        ? 3
                                        : 2,
                                mainAxisExtent: 290,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Get.to(ProductDetialsScreen(
                                                  "$image,$index",
                                                  product: wishes[index],
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
                                                              BorderRadius
                                                                  .circular(5),
                                                          child:
                                                              CachedNetworkImage(
                                                            height: 200,
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
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
                                                                value:
                                                                    downloadProgress
                                                                        .progress,
                                                              ),
                                                            ),
                                                            imageUrl:
                                                                '${wishes[index]['featured_image']}',
                                                          )))
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
                                                        BorderRadius.circular(
                                                            50)),
                                                child: wishes[index]
                                                            ['is_fav'] ==
                                                        true
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          var productID =
                                                              wishes[index]
                                                                  ['id'];
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
                                                              wishes[index]
                                                                  ['id'];
                                                          toggleFav(productID);
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
                                                    product: wishes[index],
                                                  ));
                                                },
                                                child: Container(
                                                  child: Text(
                                                    wishes[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff333333),
                                                        fontFamily:
                                                            selectedLanguage ==
                                                                    'en'
                                                                ? 'lucymar'
                                                                : 'LBC'),
                                                    textDirection:
                                                        selectedLanguage == 'en'
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: wishes.length,
                            ),
                          )
                  ]))),
    );
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
        getWishes();
      });
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }

  Future getWishes() async {
    isLoading = true;
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('wishes', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    wishes = value;
    print('wishes ${wishes}');
  }
}

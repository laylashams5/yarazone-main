import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/widgets/brands.dart';
import 'package:yarazon/widgets/categories-home.dart';
import 'package:yarazon/services/api.dart';
import 'package:yarazon/widgets/lastest-products.dart';
import 'package:yarazon/widgets/search.dart';
import 'package:yarazon/widgets/visited-products.dart';
import 'package:yarazon/models/carousel.dart';

List<Carousel> sliders = [];

class MainTabScreen extends StatefulWidget {
  MainTabScreen({Key? key}) : super(key: key);

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool sliderLoader = false;
  int _current = 0;
  List<Widget>? imageSlider;
  @override
  void initState() {
    super.initState();
    Token = storage.read('userToken');
    print('Token $Token');
    getSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                sliderLoader == true
                    ? Container(
                        height: 50,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(width: 1, color: Color(0xfff4f4f4))),
                      )
                    : SearchBar(),
                CategoriesHome(),
                SizedBox(
                  height: 15,
                ),
                sliderLoader == true
                    ? Skelton(width: 1000, height: 200)
                    : CarouselSlider(
                        items: sliders
                            .map((e) => Container(
                                  margin: EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: e.image,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error,
                                                  color: primaryColor),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                          width: 1000,
                                        ),
                                        e.title != null
                                            ? Center(
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    '${e.title}'.tr,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            selectedLanguage ==
                                                                    'en'
                                                                ? 'lucymar'
                                                                : 'LBC'),
                                                  ),
                                                ),
                                              )
                                            : Text('')
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
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
                  children: sliders.map((e) {
                    int index = sliders.indexOf(e);
                    return Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _current == index
                            ? Color.fromARGB(248, 231, 130, 8)
                            : Color.fromARGB(210, 203, 200, 200),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Brands(),
                SizedBox(
                  height: 10,
                ),
                VisitedProducts(),
                SizedBox(
                  height: 10,
                ),
                LastetProducts()
              ],
            )));
  }

  Future getSlider() async {
    sliderLoader = true;
    var headers = getHeaderNoAuth();
    var value = await ApiServices.getApi('slider', headers: headers);
    setState(() {
      sliderLoader = false;
    });
    value = json.decode(value);
    value = value['data'][0]['slider'];
    var content = value as List<dynamic>;
    sliders = content
        .map((model) => Carousel.fromJson(model as Map<String, dynamic>))
        .toList();
  }
}

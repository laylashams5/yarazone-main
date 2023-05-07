import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/models/category.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/product-detials.dart';
import 'package:yarazon/services/api.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool isLoading = false;
  List<Category> categories = [];
  List products = [];
  int initPosition = 2;
  int qty = 1;
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:
            selectedLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xfffbfbfb),
          appBar: AppBar(
            title: Text(
              'Categories'.tr,
              style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 16,
                  fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
            ),
            leading: IconButton(
              onPressed: () {
                Get.to(HomeScreen());
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
          body: isLoading == true
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: primaryColor,
                    size: 30,
                  ),
                )
              : SafeArea(
                  child: CustomTabView(
                    stub: Container(),
                    initPosition: initPosition,
                    itemCount: categories.length,
                    tabBuilder: (context, i) => Tab(
                      text: categories[i].name,
                    ),
                    pageBuilder: (context, j) => Container(
                      margin: EdgeInsets.only(
                        bottom: 8,
                        top: 8,
                      ),
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                                    left: 8, right: 8, top: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: CachedNetworkImage(
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
                                                                  value: downloadProgress
                                                                      .progress,
                                                                ),
                                                              ),
                                                      imageUrl:
                                                          '${products[index]['featured_image']}',
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
                                              maxLines: 3,
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
                                                      addToCart(products[index]
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
                    onPositionChange: (index) {
                      setState(() {
                        products = categories[index].products!;
                      });
                      print('current position: $index');
                      initPosition = index;
                    },
                    onScroll: (position) => {},
                  ),
                ),
        ));
  }

  Future  getCategories() async {
    isLoading = true;
    var headers = getHeaderAuth();
    var value = await ApiServices.getApi('categories', headers: headers);
    setState(() {
      isLoading = false;
    });
    value = json.decode(value);
    value = value['data'];
    var content = value as List<dynamic>;
    categories = content
        .map((model) => Category.fromJson(model as Map<String, dynamic>))
        .toList();
  }

  Future addToCart(var productId) async {
    isLoading = true;
    if (Token != null) {
      var body = {"product_id": "$productId", "qty": '${qty}'};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('cart/add',
          parameters: convertBody, headers: getHeaderAuth());
      showMessage('Added item to cart!'.tr);
      setState(() {
        isLoading = false;
        getCategories();
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

  Future toggleFav(var productId) async {
    if (Token != null) {
      isLoading = true;
      var body = {};
      final convertBody = json.encode(body);
      var value = await ApiServices.postApi('wishes/$productId/toggle',
          parameters: convertBody, headers: getHeaderAuth());
      var decode = json.decode(value);
      if (decode != "Removed") {
        setState(() {
          isLoading = false;
          getCategories();
        });
        showMessage('Added item to fav!'.tr);
      } else {
        setState(() {
          isLoading = false;
          getCategories();
        });
        showMessage('removed item to fav!'.tr);
      }
    } else {
      showErrorMessage('You should login'.tr);
      Get.offAll(HomeScreen(
        isLoginForm: true,
      ));
    }
  }
}

/// Implementation

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  int _currentCount = 0;
  int _currentPosition = 0;
  bool isLoading = false;
  @override
  void initState() {
    _currentPosition = widget.initPosition;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation?.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation?.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation?.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation?.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.itemCount < 1) return widget.stub ?? Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Color(0xfff4f4f4)),
          alignment: Alignment.center,
          child: TabBar(
              automaticIndicatorColorAdjustment: true,
              padding: EdgeInsets.all(3),
              labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff666666),
                  fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
              isScrollable: true,
              controller: controller,
              labelColor: primaryColor,
              unselectedLabelColor: Theme.of(context).hintColor,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
              ),
              tabs: List.generate(
                widget.itemCount,
                (index) => widget.tabBuilder(context, index),
              )),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
        isLoading == true
            ? Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: primaryColor,
                  size: 30,
                ),
              )
            : Text(''),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}

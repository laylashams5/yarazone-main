import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/helper.dart';

class LoadingIndicator extends StatelessWidget {
  final double height;
  final double width;
  const LoadingIndicator({Key? key, this.height = 50, this.width = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: primaryColor,
          size: 30,
        ),
        height: height,
        width: width,
      ),
    );
  }
}

showLoadingIndicatorDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 220,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 45,
                  child: Image.asset("assets/imgs/logo.png"),
                ),
                Center(
                    child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 100, right: 100, top: 10),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: primaryColor,
                    size: 30,
                  ),
                ))
              ],
            ),
          ),
        );
      });
}

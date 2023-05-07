import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imageURL;

  const ImageView({super.key, required this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: '',
            child: Image.network(
              imageURL,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
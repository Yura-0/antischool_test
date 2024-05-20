import 'package:flutter/material.dart';

class ImgBtn extends StatelessWidget {
  final String img;
  final double width;
  final double height;
  final void Function() onTap;
  const ImgBtn({
    super.key,
    required this.img,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(img),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

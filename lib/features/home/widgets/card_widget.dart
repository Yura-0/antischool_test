import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/img_assets.dart';

class CardWidget extends StatelessWidget {
  final String imgUrl;
  final String word;
  final String translation;
  const CardWidget({super.key, required this.imgUrl, required this.word, required this.translation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptive.w(70),
      height: Adaptive.h(60),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImgAssets.cardBack),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: Adaptive.w(50),
              height: Adaptive.h(30),
              child: Image.network(imgUrl),
              ),
            const SizedBox(height: 15),
            Text(word),
            const SizedBox(height: 15),
            Text(translation),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/api/data_manadger.dart';
import '../../core/img_assets.dart';
import '../../core/injector.dart';
import 'widgets/card_widget.dart';
import 'widgets/img_btn_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, String>>> _cardsFuture;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _cardsFuture = locator<DataManager>().fetchAndCombineData();
  }

  void _goToNextCard(List<Map<String, String>> cards) {
    if (_currentIndex < cards.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToPreviousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 11, 11),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _cardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final cards = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return CardWidget(
                        imgUrl: card['image_url']!,
                        word: card['word']!,
                        translation: card['translation']!,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ImgBtn(
                      img: ImgAssets.backBtn,
                      width: Adaptive.w(30),
                      height: Adaptive.h(10),
                      onTap:
                          _currentIndex > 0 ? () => _goToPreviousCard() : null,
                    ),
                    ImgBtn(
                      img: ImgAssets.nextBtn,
                      width: Adaptive.w(30),
                      height: Adaptive.h(10),
                      onTap: _currentIndex < cards.length - 1
                          ? () => _goToNextCard(cards)
                          : null,
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}

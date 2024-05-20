import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/api/data_manadger.dart';
import '../../core/img_assets.dart';
import '../../core/injector.dart';
import 'widgets/card_widget.dart';
import 'widgets/img_btn_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, String>> _cards = [];
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCards();
    FirebaseRemoteConfig.instance.onConfigUpdated.listen((event) {
      _loadCards();
    });
  }

  Future<void> _loadCards() async {
    try {
      final cardsData = await locator<DataManager>().fetchData();
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      final cardsOrder = remoteConfig.getString('cards_order').trim().split(',');

      _cards = cardsData.where((card) => cardsOrder.contains(card['card_id'])).toList();
      setState(() {});
    } catch (e) {
      print('Error loading cards: $e');
    }
  }

  void _goToNextCard() {
    if (_currentIndex < _cards.length - 1) {
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
      body: _cards.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Adaptive.h(10), bottom: Adaptive.h(15)),
                  child: SizedBox(
                    width: Adaptive.w(80),
                    height: Adaptive.h(62),
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return CardWidget(
                          imgUrl: card['image_url']!,
                          word: card['word']!,
                          translation: card['translation']!,
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImgBtn(
                      img: ImgAssets.backBtn,
                      width: Adaptive.w(35),
                      height: Adaptive.h(6),
                      onTap: _currentIndex > 0 ? _goToPreviousCard : null,
                    ),
                    SizedBox(width: Adaptive.w(10)),
                    ImgBtn(
                      img: ImgAssets.nextBtn,
                      width: Adaptive.w(35),
                      height: Adaptive.h(6),
                      onTap: _currentIndex < _cards.length - 1 ? _goToNextCard : null,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

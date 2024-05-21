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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
    FirebaseRemoteConfig.instance.onConfigUpdated.listen((event) {
      _changeOrder();
    });
  }

  Future<void> _loadCards() async {
    try {
      final cardsData = await locator<DataManager>().fetchData();
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      final cardsOrder = remoteConfig.getString('cards_order').trim().split(',');

      _cards = sortCards(cardsData, cardsOrder);
      setState(() {
        _isLoading = false; 
      });
    } catch (e) {
      print('Error loading cards: $e');
      setState(() {
        _isLoading = false; 
      });
      
      _showErrorMessage();
    }
  }

  void _showErrorMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Error')),
          content: const Text('Check your internet connection and restart app.', textAlign: TextAlign.center,),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeOrder () async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    final cardsOrder =
          remoteConfig.getString('cards_order').trim().split(',');
    _cards = sortCards(_cards, cardsOrder);
    setState(() {});
    } catch (e) {
      print('Error loading cards: $e');
    }
  }

  List<Map<String, String>> sortCards(List<Map<String, String>> cardsData, List<String> cardsOrder) {
 
  List<Map<String, String>> sortedCards = [];
  if (cardsOrder.length == cardsData.length) {
    for (String cardId in cardsOrder) {
    for (var card in cardsData) {
      if (card['card_id'] == cardId) {
        sortedCards.add(card);
        break;  
      }
    }
  }
  }
  else {
    sortedCards = cardsData;
  }
  

  return sortedCards;
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
                  padding: EdgeInsets.only(
                      top: Adaptive.h(10), bottom: Adaptive.h(15)),
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
                      onTap: _currentIndex < _cards.length - 1
                          ? _goToNextCard
                          : null,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

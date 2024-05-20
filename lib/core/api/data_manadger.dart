import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../injector.dart';
import 'cards_sheets_api.dart';
import 'firestore_api.dart';

class DataManager {
  Future<List<Map<String, String>>> fetchAndCombineData() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1)),
    );
    await remoteConfig.fetchAndActivate();

    final cardsOrder = remoteConfig.getString('cards_order').split(',');

    final data = await locator<CardsSheetsAPI>().fetchSheetData();

    for (var row in data) {
      final imageUrl =
          await locator<FirestoreAPI>().getImageUrl(row['image_id']!);
      row['image_url'] = imageUrl;
    }
    data.sort((a, b) => cardsOrder
        .indexOf(a['card_id']!)
        .compareTo(cardsOrder.indexOf(b['card_id']!)));

    return data;
  }
}

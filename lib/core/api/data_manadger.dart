
import '../injector.dart';
import 'cards_sheets_api.dart';
import 'firestore_api.dart';

class DataManager {
  Future<List<Map<String, String>>> fetchData() async {
    final data = await locator<CardsSheetsAPI>().fetchSheetData();
    for (var row in data) {
      try {
        final imageUrl = await locator<FirestoreAPI>().getImageUrl(row['image_id'] ?? '');
        row['image_url'] = imageUrl;
      } catch (e) {
        row['image_url'] = '';
      }
      
    }
    return data;
  }
}


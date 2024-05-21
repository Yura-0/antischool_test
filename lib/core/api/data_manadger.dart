
import '../model/i_data_storage.dart';
import '../model/i_image_storage.dart';

class DataManager {
  final IDataStorage datas;
  final IImageStorage image;

  DataManager({required this.datas, required this.image});

  Future<List<Map<String, String>>> fetchData() async {
    final data = await datas.fetchSheetData();
    for (var row in data) {
      try {
        final imageUrl = await image.getImageUrl(row['image_id'] ?? '');
        row['image_url'] = imageUrl;
      } catch (e) {
        row['image_url'] = '';
      }
      
    }
    return data;
  }
}


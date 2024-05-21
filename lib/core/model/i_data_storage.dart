abstract class IDataStorage {
  Future<void> init();
  Future<List<Map<String, String>>> fetchSheetData();
}
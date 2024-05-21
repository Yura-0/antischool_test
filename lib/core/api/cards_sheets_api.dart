import 'package:gsheets/gsheets.dart';

import '../../secret_consts.dart';
import '../model/cards_fields.dart';
import '../model/i_data_storage.dart';

class CardsSheetsAPI implements IDataStorage{
  static const String _spreadsheetId = SecConsts.spreadsheetId;
  static const String _credentials = SecConsts.credentials;
  static final _gsheets = GSheets(_credentials);

  Worksheet? _cardsSheet;

  @override
  Future<void> init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _cardsSheet = await _getWorkSheets(spreadsheet, title: 'Cards');

      final firstRow = CardsFields.getFields();
      _cardsSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print("Init error: $e");
    }
  }

  Future<Worksheet> _getWorkSheets(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  @override
  Future<List<Map<String, String>>> fetchSheetData() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('Cards');

    final data = await sheet!.values.map.allRows();
    return data!
        .map(
          (row) => {
            'card_id': row['Card ID']!,
            'word': row['Word']!,
            'translation': row['Translation']!,
            'image_id': row['Image ID']!,
          },
        )
        .toList();
  }
}

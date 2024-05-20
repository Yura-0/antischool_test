import 'package:gsheets/gsheets.dart';

import '../../secret_consts.dart';
import '../model/cards_fields.dart';

abstract class CardsSheetsAPI {
  static const String _spreadsheetId =
      SecConsts.spreadsheetId;
  static const String _credentials = SecConsts.credentials;
  static final _gsheets = GSheets(_credentials);
  
  static Worksheet? _cardsSheet;

  static Future init() async {
   try {
    final spreadsheet =  await _gsheets.spreadsheet(_spreadsheetId);
   _cardsSheet = await _getWorkSheets(spreadsheet, title: 'Cards');

   final firstRow = CardsFields.getFields();
   _cardsSheet!.values.insertRow(1, firstRow);
   } catch (e) {
    print("Init error: $e");
   }
  }
  
  static Future<Worksheet> _getWorkSheets(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    }
    catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
}
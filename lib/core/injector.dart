import 'package:get_it/get_it.dart';

import 'api/cards_sheets_api.dart';
import 'api/data_manadger.dart';
import 'api/firestore_api.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => CardsSheetsAPI());
  locator.registerLazySingleton(() => FirestoreAPI());
  locator.registerLazySingleton(() => DataManager());
}

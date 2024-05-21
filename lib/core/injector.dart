import 'package:get_it/get_it.dart';

import 'api/cards_sheets_api.dart';
import 'api/data_manadger.dart';
import 'api/firestore_api.dart';
import 'model/i_data_storage.dart';
import 'model/i_image_storage.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // register APIs
  locator.registerLazySingleton<IDataStorage>(() => CardsSheetsAPI());
  locator.registerLazySingleton<IImageStorage>(() => FirestoreAPI());
  // register models
  locator.registerLazySingleton(() => DataManager(
        datas: locator<IDataStorage>(),
        image: locator<IImageStorage>(),
      ));
}

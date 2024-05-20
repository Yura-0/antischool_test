import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/api/cards_sheets_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBtpk4rrr0V-jLMTjWhOMAaaOn8T6Blt2Q',
      appId: '1:641995186213:android:e6c00fe2c5f03b8691dfcc',
      messagingSenderId: '641995186213',
      projectId: 'antitest-1bc1f',
      storageBucket: 'antitest-1bc1f.appspot.com',
    ),
  );
  await CardsSheetsAPI.init();
  runApp(const TestApp());
}

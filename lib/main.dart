import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBtpk4rrr0V-jLMTjWhOMAaaOn8T6Blt2Q',
      appId: '1:641995186213:android:e6c00fe2c5f03b8691dfcc',
      messagingSenderId: '641995186213',
      projectId: 'antitest-1bc1f',
      storageBucket: 'antitest-1bc1f.appspot.com',
    ),
  );
  runApp(const TestApp());
}

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'features/home/home_screen.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: const HomeScreen(),
      );
    });
  }
}

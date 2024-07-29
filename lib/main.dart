import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:delivery_flutter_app/common/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: PRIMARY_COLOR),
        useMaterial3: false,
        fontFamily: 'NotoSans',
      ),
      home: const SplashScreen(),
    );
  }
}

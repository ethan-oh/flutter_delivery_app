import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: Center(
          child: Image.asset(
            'asset/img/logo/ethan_logo.png',
            width: MediaQuery.of(context).size.width / 1.5,
          ),
        ));
  }
}
